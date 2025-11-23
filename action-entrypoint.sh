#!/bin/bash
# GitHub Action entrypoint for markdown-to-pdf converter
# This script processes GitHub Action inputs and converts markdown files to PDF

set -e

# Get inputs from environment variables (set by composite action)
FILES_INPUT="${FILES_INPUT:-}"
CONFIG_FILE="${CONFIG_FILE:-}"
OUTPUT_DIR="${OUTPUT_DIR:-Docs}"
WORKING_DIR="${WORKING_DIR:-.}"
FAIL_ON_ERROR="${FAIL_ON_ERROR:-true}"
CONTAINER_IMAGE="${CONTAINER_IMAGE:-ghcr.io/tmichett/md2pdf:latest}"

# Change to working directory if specified
if [ "$WORKING_DIR" != "." ] && [ -d "$WORKING_DIR" ]; then
  cd "$WORKING_DIR"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Track results
SUCCESSFUL_PDFS=()
FAILED_FILES=()
TOTAL_PROCESSED=0

echo "::group::📄 Markdown to PDF Conversion"
echo "Output directory: $OUTPUT_DIR"
echo "Working directory: $(pwd)"
echo ""

# Function to convert a single file
convert_file() {
  local input_file="$1"
  local output_file="$2"
  
  if [ ! -f "$input_file" ]; then
    echo "⚠️  Warning: File not found: $input_file"
    return 1
  fi
  
  echo "📄 Processing: $input_file"
  
  # Get absolute paths
  if command -v realpath &> /dev/null; then
    INPUT_ABS=$(realpath "$input_file")
    OUTPUT_ABS=$(realpath "$output_file")
    WORKSPACE_ABS=$(realpath "$(pwd)")
  else
    # Fallback if realpath not available
    INPUT_ABS="$input_file"
    OUTPUT_ABS="$output_file"
    WORKSPACE_ABS="$(pwd)"
    # Convert to absolute if relative
    if [[ ! "$INPUT_ABS" = /* ]]; then
      INPUT_ABS="$WORKSPACE_ABS/$INPUT_ABS"
    fi
    if [[ ! "$OUTPUT_ABS" = /* ]]; then
      OUTPUT_ABS="$WORKSPACE_ABS/$OUTPUT_ABS"
    fi
  fi
  
  # Use repository root (current directory) as mount point
  MOUNT_DIR="$WORKSPACE_ABS"
  
  # Get relative paths from workspace root
  INPUT_REL="${INPUT_ABS#$WORKSPACE_ABS/}"
  OUTPUT_REL="${OUTPUT_ABS#$WORKSPACE_ABS/}"
  
  CONTAINER_INPUT="/workspace/$INPUT_REL"
  CONTAINER_OUTPUT="/workspace/$OUTPUT_REL"
  
  # Run the container
  if docker run --rm \
    -v "$MOUNT_DIR:/workspace:rw" \
    -w /workspace \
    "$CONTAINER_IMAGE" \
    "$CONTAINER_INPUT" \
    "$CONTAINER_OUTPUT" 2>&1; then
    
    if [ -f "$output_file" ]; then
      file_size=$(du -h "$output_file" | cut -f1)
      echo "✅ Successfully created: $output_file ($file_size)"
      SUCCESSFUL_PDFS+=("$output_file")
      return 0
    else
      echo "❌ Error: PDF was not created: $output_file"
      return 1
    fi
  else
    echo "❌ Error: Failed to convert $input_file"
    return 1
  fi
}

# Process files from input
if [ -n "$FILES_INPUT" ]; then
  echo "Processing files from input list..."
  IFS=',' read -ra FILES_ARRAY <<< "$FILES_INPUT"
  for file in "${FILES_ARRAY[@]}"; do
    file=$(echo "$file" | xargs) # Trim whitespace
    if [ -n "$file" ]; then
      TOTAL_PROCESSED=$((TOTAL_PROCESSED + 1))
      input_file="$file"
      # Generate output filename
      basename=$(basename "$file" .md)
      output_file="$OUTPUT_DIR/${basename}.pdf"
      
      if ! convert_file "$input_file" "$output_file"; then
        FAILED_FILES+=("$file")
        if [ "$FAIL_ON_ERROR" = "true" ]; then
          echo "::error::Failed to convert $file"
        fi
      fi
      echo ""
    fi
  done
fi

# Process files from config file
if [ -n "$CONFIG_FILE" ] && [ -f "$CONFIG_FILE" ]; then
  echo "Processing files from config: $CONFIG_FILE"
  
  # Check if yq is available for YAML parsing, otherwise use a simple parser
  if command -v yq &> /dev/null; then
    # Use yq to parse YAML
    while IFS= read -r file_path; do
      if [ -n "$file_path" ]; then
        TOTAL_PROCESSED=$((TOTAL_PROCESSED + 1))
        input_file="$file_path"
        basename=$(basename "$file_path" .md)
        output_file="$OUTPUT_DIR/${basename}.pdf"
        
        if ! convert_file "$input_file" "$output_file"; then
          FAILED_FILES+=("$file_path")
          if [ "$FAIL_ON_ERROR" = "true" ]; then
            echo "::error::Failed to convert $file_path"
          fi
        fi
        echo ""
      fi
    done < <(yq eval '.files[].path' "$CONFIG_FILE")
  else
    # Simple YAML parser for files array
    echo "⚠️  yq not found, using simple YAML parser"
    in_files=false
    while IFS= read -r line; do
      # Check if we're in the files section
      if [[ "$line" =~ ^files: ]]; then
        in_files=true
        continue
      fi
      
      # Stop if we hit another top-level key
      if [[ "$line" =~ ^[a-zA-Z_]+: ]] && [ "$in_files" = true ]; then
        break
      fi
      
      # Extract file path
      if [ "$in_files" = true ] && [[ "$line" =~ -[[:space:]]*path:[[:space:]]*(.+) ]]; then
        file_path="${BASH_REMATCH[1]}"
        # Remove quotes if present
        file_path=$(echo "$file_path" | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
        
        if [ -n "$file_path" ]; then
          TOTAL_PROCESSED=$((TOTAL_PROCESSED + 1))
          input_file="$file_path"
          basename=$(basename "$file_path" .md)
          output_file="$OUTPUT_DIR/${basename}.pdf"
          
          if ! convert_file "$input_file" "$output_file"; then
            FAILED_FILES+=("$file_path")
            if [ "$FAIL_ON_ERROR" = "true" ]; then
              echo "::error::Failed to convert $file_path"
            fi
          fi
          echo ""
        fi
      fi
    done < "$CONFIG_FILE"
  fi
fi

echo "::endgroup::"

# Summary
echo "::group::📊 Conversion Summary"
echo "Total processed: $TOTAL_PROCESSED"
echo "Successful: ${#SUCCESSFUL_PDFS[@]}"
echo "Failed: ${#FAILED_FILES[@]}"
echo ""

if [ ${#SUCCESSFUL_PDFS[@]} -gt 0 ]; then
  echo "✅ Successfully generated PDFs:"
  for pdf in "${SUCCESSFUL_PDFS[@]}"; do
    echo "  - $pdf"
  done
  echo ""
fi

if [ ${#FAILED_FILES[@]} -gt 0 ]; then
  echo "❌ Failed to convert:"
  for file in "${FAILED_FILES[@]}"; do
    echo "  - $file"
  done
  echo ""
fi
echo "::endgroup::"

# Set outputs (using new GITHUB_OUTPUT format if available, fallback to old format)
PDF_LIST=$(IFS=','; echo "${SUCCESSFUL_PDFS[*]}")
if [ -n "$GITHUB_OUTPUT" ]; then
  {
    echo "pdfs=$PDF_LIST"
    echo "pdf_count=${#SUCCESSFUL_PDFS[@]}"
  } >> "$GITHUB_OUTPUT"
else
  # Fallback to old format for compatibility
  echo "::set-output name=pdfs::$PDF_LIST"
  echo "::set-output name=pdf_count::${#SUCCESSFUL_PDFS[@]}"
fi

# Exit with error if failures occurred and fail_on_error is true
if [ ${#FAILED_FILES[@]} -gt 0 ] && [ "$FAIL_ON_ERROR" = "true" ]; then
  echo "::error::Some PDF conversions failed"
  exit 1
fi

if [ ${#SUCCESSFUL_PDFS[@]} -eq 0 ] && [ $TOTAL_PROCESSED -gt 0 ]; then
  echo "::error::No PDFs were successfully generated"
  exit 1
fi

echo "✅ All conversions completed successfully!"

