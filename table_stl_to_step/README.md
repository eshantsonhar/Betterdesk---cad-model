# Table STL to STEP Conversion Project

This project provides a single-click automated workflow for converting a 3D table mesh (`final_table_1.5m.7z`) into a CAD-compatible B-Rep STEP solid file (`output\final_table_1.5m.step`).

---

## 📜 Credits and Attribution

This project incorporates and uses the **2STEP Converter** software from the following upstream repository:

- **Project Name:** 2STEP Converter
- **Original Repository:** [https://github.com/yaneony/2STEP-Converter](https://github.com/yaneony/2STEP-Converter)
- **Original Author/Maintainer:** YaneonY

### Ownership & License Notice
- The core conversion logic, OpenCASCADE B-Rep sewing pipeline, and Python conversion code belong entirely to **YaneonY** and contributors of the original **2STEP Converter** project.
- No claim of creation or ownership is made over 2STEP Converter by this wrapper project.
- **2STEP Converter** is distributed under the terms of the **MIT License** (Copyright (c) 2026 YaneonY). The complete original license text and copyright notice are preserved in [`2STEP-Converter/LICENSE.md`](file:///C:/Eshant_Sonhar/3D%20Models/table_stl_to_step/2STEP-Converter/LICENSE.md).

---

## 🎯 Purpose of This Repository

This workspace wraps the **2STEP Converter** source code along with an archive containing a 3D table model (`final_table_1.5m.7z`). 

When executed, the project performs the following automated tasks:
1. Locates 7-Zip on the local machine and prepares the environment.
2. Builds/sets up a self-contained Python + OpenCASCADE runtime environment inside `build/` using `micromamba` and the original `2STEP-Converter/src/environment.yml` specification.
3. Extracts `final_table_1.5m.7z` into the `input_extracted/` directory.
4. Finds the extracted STL model.
5. Converts the STL mesh to a STEP CAD solid using the locally built 2STEP Converter.
6. Saves the converted STEP solid to `output\final_table_1.5m.step`.

---

## 📁 Directory Structure

```text
table_stl_to_step/
├── final_table_1.5m.7z      # Input compressed 7z archive containing table STL
├── convert_table.bat        # One-click Windows batch wrapper script (DO NOT RUN AUTOMATICALLY)
├── README.md                # Project documentation and attribution
│
├── 2STEP-Converter/         # Full cloned source code of 2STEP Converter
│   ├── LICENSE.md           # Original MIT License
│   ├── README.md            # Original 2STEP Converter documentation
│   ├── 2STEP-Converter.bat  # Upstream launcher script
│   └── src/
│       ├── converter.py     # Main Python conversion engine
│       └── environment.yml  # Conda environment definition
│
├── build/                   # Directory for locally built Python/OpenCASCADE environment
├── input_extracted/         # Directory where 7z archive extracts the STL model
└── output/                  # Directory where final converted STEP solid is saved
```

---

## 🚀 How to Run the Conversion

> [!IMPORTANT]
> **Manual Execution Only:** The automated workflow should be initiated by double-clicking `convert_table.bat`. Setting up this workspace did **NOT** execute the build, extraction, or conversion process.

### Steps:
1. Ensure **7-Zip** is installed on your Windows machine (download from [https://www.7-zip.org/](https://www.7-zip.org/)).
2. Double-click `convert_table.bat` inside `C:\Eshant_Sonhar\3D Models\table_stl_to_step`.
3. The script will automatically perform:
   ```text
   final_table_1.5m.7z
   ↓
   [1/4] Check dependencies & 2STEP-Converter source
   ↓
   [2/4] Build local environment in build/ (one-time setup)
   ↓
   [3/4] Extract archive into input_extracted/ & locate STL
   ↓
   [4/4] Convert STL -> STEP using 2STEP Converter
   ↓
   output\final_table_1.5m.step
   ```
4. Once completed, inspect `output\final_table_1.5m.step` in your preferred CAD application (e.g. FreeCAD, SolidWorks, Autodesk Fusion, Rhino).

---

## 🛠 Prerequisites & Dependencies

The `convert_table.bat` script handles setup automatically, but relies on:
- **Windows OS**
- **7-Zip** (`7z.exe` in standard Program Files path or system PATH)
- **Internet connection** (required during the initial run to download `micromamba` and dependencies defined in `environment.yml`).
