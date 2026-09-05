#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# Table STL -> STEP Converter
# Linux / Kubuntu
#
# Usage:
#   chmod +x convert_table.sh
#   ./convert_table.sh
# ============================================================


# ============================================================
# Re-open in Konsole when launched without a terminal
# ============================================================

if [ ! -t 1 ]; then
    if command -v konsole >/dev/null 2>&1; then
        exec konsole --hold -e bash "$0" "$@"
    else
        echo "[ERROR] Konsole was not found."
        echo ""
        echo "Install it with:"
        echo "    sudo apt install konsole"
        echo ""
        exit 1
    fi
fi


# ============================================================
# Error handler
# ============================================================

error_exit() {
    echo ""
    echo "========================================"
    echo "ERROR"
    echo "========================================"
    echo "$1"
    echo ""
    echo "The converter did not complete successfully."
    echo ""
    read -r -p "Press Enter to exit..."
    exit 1
}


# ============================================================
# Header
# ============================================================

echo "========================================"
echo "Table STL -> STEP Converter"
echo "========================================"
echo ""


# ============================================================
# Get script directory
# ============================================================

PROJ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ARCHIVE_FILE_1="${PROJ_DIR}/final_table_1.5m.7z"
ARCHIVE_FILE_2="${PROJ_DIR}/final_table_1-5m.7z"

if [ -f "${ARCHIVE_FILE_1}" ]; then
    ARCHIVE_FILE="${ARCHIVE_FILE_1}"
elif [ -f "${ARCHIVE_FILE_2}" ]; then
    ARCHIVE_FILE="${ARCHIVE_FILE_2}"
else
    error_exit "Input archive was not found.

Expected one of:

    ${ARCHIVE_FILE_1}
    ${ARCHIVE_FILE_2}"
fi


EXTRACT_DIR="${PROJ_DIR}/input_extracted"
OUTPUT_DIR="${PROJ_DIR}/output"
BUILD_DIR="${PROJ_DIR}/build"
CONVERTER_DIR="${PROJ_DIR}/2STEP-Converter"

OUTPUT_STEP="${OUTPUT_DIR}/final_table_1-5m.step"


# ============================================================
# Stage 1
# ============================================================

echo "[1/4] Preparing 2STEP Converter..."
echo ""


# ============================================================
# Check required system commands
# ============================================================

if ! command -v uname >/dev/null 2>&1; then
    error_exit "The 'uname' command was not found."
fi

if ! command -v curl >/dev/null 2>&1; then
    error_exit "curl was not found.

Install it with:

    sudo apt install curl"
fi

if ! command -v sha256sum >/dev/null 2>&1; then
    error_exit "sha256sum was not found.

Install the required core utilities with:

    sudo apt install coreutils"
fi


# ============================================================
# Check 7-Zip / Extractor
# ============================================================

SEVENZIP=""

if command -v 7zz >/dev/null 2>&1; then
    SEVENZIP="7zz"
elif command -v 7z >/dev/null 2>&1; then
    SEVENZIP="7z"
else
    error_exit "7-Zip was not found.

Install it with:

    sudo apt install 7zip

If your Kubuntu version uses the older package:

    sudo apt install p7zip-full"
fi


# ============================================================
# Check Git
# ============================================================

if ! command -v git >/dev/null 2>&1; then
    error_exit "Git was not found.

Install it with:

    sudo apt install git"
fi


# ============================================================
# Check 2STEP Converter source
# ============================================================

if [ ! -f "${CONVERTER_DIR}/src/converter.py" ]; then

    echo "[INFO] 2STEP Converter source code is missing."
    echo "[INFO] Cloning from GitHub..."
    echo ""

    if [ -d "${CONVERTER_DIR}" ]; then
        echo "[INFO] Existing incomplete 2STEP-Converter directory detected."
        echo "[INFO] Removing incomplete directory..."
        rm -rf "${CONVERTER_DIR}"
    fi

    if ! git clone \
        https://github.com/yaneony/2STEP-Converter.git \
        "${CONVERTER_DIR}"
    then
        error_exit "Git failed to clone the 2STEP Converter repository."
    fi
fi


if [ ! -f "${CONVERTER_DIR}/src/converter.py" ]; then
    error_exit "2STEP Converter source was not found after cloning:

    ${CONVERTER_DIR}/src/converter.py"
fi


# ============================================================
# Create directories
# ============================================================

mkdir -p \
    "${BUILD_DIR}" \
    "${OUTPUT_DIR}" \
    "${EXTRACT_DIR}"


# ============================================================
# Stage 2
# ============================================================

echo "[2/4] Building 2STEP Converter environment..."
echo ""


_MM_ROOT="${BUILD_DIR}"
_MM="${_MM_ROOT}/micromamba"
_ENV="${_MM_ROOT}/env"
_PY="${_ENV}/bin/python"
_SPEC="${CONVERTER_DIR}/src/environment.yml"


# ============================================================
# Detect Linux architecture
# ============================================================

ARCH="$(uname -m)"

case "${ARCH}" in

    x86_64)
        MM_URL="https://github.com/mamba-org/micromamba-releases/releases/download/2.8.1-1/micromamba-linux-64"
        MM_SHA256="77b7790ec97f64581118f103585b175df4306f95829b0fa6bfe4a19cc88a1182"
        ;;

    aarch64|arm64)
        MM_URL="https://github.com/mamba-org/micromamba-releases/releases/download/2.8.1-1/micromamba-linux-aarch64"
        MM_SHA256="49aa2908cafa6cd6027ebd643fc43ca32c20740e60b0a05378c4e5bb837c217"
        ;;

    *)
        error_exit "Unsupported Linux architecture:

    ${ARCH}

Supported architectures:

    x86_64
    aarch64 / arm64"
        ;;

esac


echo "Detected Linux architecture: ${ARCH}"
echo ""


# ============================================================
# Micromamba environment variables
# ============================================================

export MAMBA_ROOT_PREFIX="${_MM_ROOT}"
export CONDA_PKGS_DIRS="${_MM_ROOT}"
export PYTHONNOUSERSITE=1
export PATH="${_ENV}/bin:${PATH}"


# ============================================================
# Download / validate micromamba
#
# This deliberately validates an existing binary.
#
# This prevents the exact problem we encountered:
#
#   Mach-O 64-bit x86_64
#
# being mistaken for a valid Linux binary.
# ============================================================

_NEED_MICROMAMBA_DOWNLOAD=0


if [ -f "${_MM}" ]; then

    echo "Checking existing micromamba binary..."

    _EXISTING_HASH="$(sha256sum "${_MM}" | awk '{print $1}')"

    if [ "${_EXISTING_HASH}" != "${MM_SHA256}" ]; then

        echo "[WARNING] Existing micromamba binary is not the expected Linux binary."
        echo "[INFO] Removing invalid micromamba..."
        echo ""

        rm -f "${_MM}"

        _NEED_MICROMAMBA_DOWNLOAD=1

    else

        chmod +x "${_MM}"

        # Actually execute it.
        # This catches things such as a Mach-O macOS executable
        # even if the file happens to have the expected permissions.

        if ! "${_MM}" --version >/dev/null 2>&1; then

            echo "[WARNING] Existing micromamba binary cannot execute on this system."
            echo "[INFO] Removing invalid micromamba..."
            echo ""

            rm -f "${_MM}"

            _NEED_MICROMAMBA_DOWNLOAD=1

        else

            echo "Existing micromamba binary is valid."
            echo ""

        fi
    fi

else
    _NEED_MICROMAMBA_DOWNLOAD=1
fi


# ============================================================
# Download correct Linux micromamba
# ============================================================

if [ "${_NEED_MICROMAMBA_DOWNLOAD}" -eq 1 ]; then

    echo "Downloading portable Python environment manager (micromamba)..."
    echo ""
    echo "URL:"
    echo "    ${MM_URL}"
    echo ""

    _TEMP_MM="${_MM}.download"

    rm -f "${_TEMP_MM}"

    if ! curl \
        --fail \
        --location \
        --show-error \
        --retry 3 \
        --retry-delay 2 \
        --connect-timeout 15 \
        --max-time 300 \
        -o "${_TEMP_MM}" \
        "${MM_URL}"
    then

        rm -f "${_TEMP_MM}"

        error_exit "Failed to download micromamba.

Check your internet connection and try again."
    fi


    chmod +x "${_TEMP_MM}"


    # --------------------------------------------------------
    # Verify SHA-256
    # --------------------------------------------------------

    _DOWNLOADED_HASH="$(sha256sum "${_TEMP_MM}" | awk '{print $1}')"


    if [ "${_DOWNLOADED_HASH}" != "${MM_SHA256}" ]; then

        rm -f "${_TEMP_MM}"

        error_exit "micromamba checksum verification failed.

Expected:

    ${MM_SHA256}

Received:

    ${_DOWNLOADED_HASH}"
    fi


    # --------------------------------------------------------
    # Replace old binary only after checksum succeeds
    # --------------------------------------------------------

    mv -f "${_TEMP_MM}" "${_MM}"

    chmod +x "${_MM}"


    # --------------------------------------------------------
    # Actually execute micromamba
    # --------------------------------------------------------

    if ! "${_MM}" --version >/dev/null 2>&1; then

        rm -f "${_MM}"

        error_exit "The downloaded micromamba binary cannot execute on this Linux system.

The download was rejected."

    fi


    echo ""
    echo "micromamba downloaded and verified successfully."
    echo ""

fi


# ============================================================
# Final micromamba verification
# ============================================================

if ! "${_MM}" --version >/dev/null 2>&1; then
    error_exit "micromamba could not be executed:

    ${_MM}"
fi


MM_VERSION="$("${_MM}" --version)"

echo "Using micromamba: ${MM_VERSION}"
echo ""


# ============================================================
# Check environment specification
# ============================================================

if [ ! -f "${_SPEC}" ]; then
    error_exit "2STEP Converter environment specification was not found:

    ${_SPEC}"
fi


# ============================================================
# Calculate environment specification hash
# ============================================================

_SPEC_HASH="$(sha256sum "${_SPEC}" | awk '{print $1}')"
_SPEC_MARKER="${_ENV}/.2step-environment.sha256"


# ============================================================
# Create or update Python environment
# ============================================================

if [ -f "${_PY}" ]; then

    _INSTALLED_SPEC_HASH=""

    if [ -f "${_SPEC_MARKER}" ]; then
        _INSTALLED_SPEC_HASH="$(cat "${_SPEC_MARKER}")"
    fi


    if [ "${_INSTALLED_SPEC_HASH}" != "${_SPEC_HASH}" ]; then

        echo "Environment specification changed."
        echo "Updating dependencies..."
        echo ""

        if ! "${_MM}" install \
            --prefix "${_ENV}" \
            --file "${_SPEC}" \
            --yes
        then
            error_exit "Python environment update failed."
        fi

    else

        echo "Python environment already exists and matches"
        echo "the current environment specification."
        echo ""

    fi

else

    echo "Creating standalone Python environment for 2STEP Converter."
    echo "This is a one-time setup and may take several minutes."
    echo ""

    if ! "${_MM}" create \
        --prefix "${_ENV}" \
        --file "${_SPEC}" \
        --yes
    then
        error_exit "Python environment creation failed."
    fi

fi


# ============================================================
# Verify Python executable exists
# ============================================================

if [ ! -x "${_PY}" ]; then
    error_exit "Python environment was created but Python was not found:

    ${_PY}"
fi


# ============================================================
# Dependency sanity check
# ============================================================

echo ""
echo "Verifying 2STEP Converter Python dependencies..."
echo ""


if ! "${_PY}" -c \
    "from OCC.Core.StlAPI import StlAPI_Reader; import numpy, trimesh, networkx, fast_simplification, matplotlib, open3d, PIL" \
    >/dev/null 2>&1
then

    echo "Python environment dependencies are incomplete."
    echo "Repairing the environment..."
    echo ""

    if ! "${_MM}" install \
        --prefix "${_ENV}" \
        --file "${_SPEC}" \
        --force-reinstall \
        --yes
    then
        error_exit "Python environment repair failed."
    fi


    if ! "${_PY}" -c \
        "from OCC.Core.StlAPI import StlAPI_Reader; import numpy, trimesh, networkx, fast_simplification, matplotlib, open3d, PIL" \
        >/dev/null 2>&1
    then

        error_exit "Python environment verification failed after repair."

    fi

fi


# ============================================================
# Save environment specification marker
# ============================================================

echo "${_SPEC_HASH}" > "${_SPEC_MARKER}"


echo "2STEP Converter environment ready."
echo ""


# ============================================================
# Configure 2STEP Converter
# ============================================================

mkdir -p "${CONVERTER_DIR}/data"


cat << 'EOF' > "${CONVERTER_DIR}/data/config.json"
{
    "SEWING_TOLERANCE": 0.01,
    "DEFAULT_REDUCTION_PERCENT": 0,
    "AUTO_REDUCTION_ENABLED": true,
    "AUTO_REDUCTION_TARGET_TRIANGLES": 50000,
    "ASK_FOR_REDUCTION": true,
    "SKIP_UP_TO_DATE_OUTPUTS": true,
    "PLANAR_MERGE_ANGLE_RADIANS": 0.01,
    "SEWING_TIMEOUT_SECONDS": 3600,
    "SEW_PARTS_SEPARATELY": true,
    "DEFAULT_STEP_FORMAT": "ap203",
    "GENERATE_PNG_PREVIEW": true,
    "INPUT_FOLDER_NAME": "models",
    "CHECK_MESH_QUALITY": true,
    "REPAIR_MESH_BEFORE_CONVERSION": true,
    "VERTEX_MERGE_DISTANCE": 0.0,
    "FIX_TRIANGLE_ORIENTATION": true,
    "REMOVE_NON_MANIFOLD_TRIANGLES": false,
    "REJECT_NON_MANIFOLD_MESH": false,
    "FILL_SMALL_MESH_HOLES": false,
    "FILL_SMALL_PLANAR_BREP_GAPS": true,
    "MAX_BREP_GAP_EDGE_COUNT": 8,
    "MAX_BREP_GAP_AREA_RATIO": 0.005,
    "CHECK_SELF_INTERSECTIONS": true,
    "SELF_INTERSECTION_CHECK_MAX_TRIANGLES": 50000,
    "REJECT_SELF_INTERSECTING_MESH": false,
    "USE_SCALE_AWARE_SEWING_TOLERANCE": true,
    "SCALE_AWARE_SEWING_TOLERANCE_RATIO": 1e-06,
    "REQUIRE_SOLID_OUTPUT": false,
    "VALIDATE_STEP_AFTER_WRITING": false,
    "PRESERVE_BOUNDARIES_DURING_REDUCTION": true,
    "REDUCTION_BOUNDARY_WEIGHT": 10.0,
    "MAX_REDUCTION_SIZE_CHANGE_PERCENT": 10.0,
    "MAX_REDUCTION_VOLUME_CHANGE_PERCENT": 10.0,
    "EXPERIMENTAL_PARAMETRIC_RECONSTRUCTION": false,
    "EXPERIMENTAL_PARAMETRIC_FIT_ERROR_RATIO": 0.0005,
    "EXPERIMENTAL_PARAMETRIC_MAX_VOLUME_CHANGE_PERCENT": 0.1,
    "RECONSTRUCT_ANALYTIC_PRIMITIVES": true,
    "ANALYTIC_PRIMITIVE_FIT_ERROR_RATIO": 0.001,
    "ANALYTIC_PRIMITIVE_MIN_TRIANGLES": 32,
    "RECONSTRUCT_ANALYTIC_THROUGH_HOLES": true,
    "RECONSTRUCT_ANALYTIC_BLIND_HOLES": true,
    "ANALYTIC_HOLE_FIT_ERROR_RATIO": 0.002,
    "ANALYTIC_HOLE_MIN_SIDES": 12,
    "ANALYTIC_HOLE_MAX_RADIUS_DIFFERENCE_RATIO": 0.002,
    "ANALYTIC_HOLE_AXIS_TOLERANCE_RADIANS": 0.005,
    "ANALYTIC_HOLE_MAX_VOLUME_CHANGE_PERCENT": 0.1,
    "STL_FILE_EXTENSION": ".stl",
    "THREE_MF_FILE_EXTENSION": ".3mf",
    "OBJ_FILE_EXTENSION": ".obj",
    "IGES_FILE_EXTENSION": ".igs",
    "AMF_FILE_EXTENSION": ".amf",
    "STEP_FILE_EXTENSION": ".stp"
}
EOF


# ============================================================
# Stage 3
# ============================================================

echo "[3/4] Extracting STL from archive..."
echo ""
echo "Archive:"
echo "    ${ARCHIVE_FILE}"
echo ""
echo "Target:"
echo "    ${EXTRACT_DIR}"
echo ""


if ! "${SEVENZIP}" x \
    "${ARCHIVE_FILE}" \
    -o"${EXTRACT_DIR}" \
    -y
then
    error_exit "7-Zip failed to extract:

    ${ARCHIVE_FILE}"
fi


# ============================================================
# Find STL
# ============================================================

FOUND_STL=""

while IFS= read -r -d '' _STL_FILE; do
    FOUND_STL="${_STL_FILE}"
    break
done < <(find "${EXTRACT_DIR}" -type f -iname "*.stl" -print0)


if [ -z "${FOUND_STL}" ]; then
    error_exit "No .stl file was found inside:

    ${ARCHIVE_FILE}

Extracted contents were placed in:

    ${EXTRACT_DIR}"
fi


echo ""
echo "Found STL file:"
echo "    ${FOUND_STL}"
echo ""


# ============================================================
# Stage 4
# ============================================================

echo "[4/4] Converting STL -> STEP..."
echo ""
echo "Input STL:"
echo "    ${FOUND_STL}"
echo ""
echo "Output STEP:"
echo "    ${OUTPUT_STEP}"
echo ""
echo "----------------------------------------"
echo "2STEP-Converter output:"
echo "----------------------------------------"
echo ""


# ============================================================
# Run converter
#
# stdout/stderr are deliberately NOT redirected.
# This gives live converter output in Konsole.
# ============================================================

if ! "${_PY}" \
    "${CONVERTER_DIR}/src/converter.py" \
    "${FOUND_STL}" \
    --output "${OUTPUT_STEP}" \
    --reduce 80 \
    --no-pause
then

    error_exit "Conversion from STL to STEP failed."
fi


# ============================================================
# Verify output
# ============================================================

if [ ! -f "${OUTPUT_STEP}" ]; then
    error_exit "The converter finished without creating the expected STEP file:

    ${OUTPUT_STEP}"
fi


# ============================================================
# Success
# ============================================================

echo ""
echo "----------------------------------------"
echo "2STEP-Converter finished."
echo "----------------------------------------"
echo ""
echo "========================================"
echo "SUCCESS: STL converted to STEP successfully!"
echo "========================================"
echo ""
echo "Output STEP file:"
echo ""
echo "    ${OUTPUT_STEP}"
echo ""
echo "========================================"
echo ""

read -r -p "Press Enter to continue..."
