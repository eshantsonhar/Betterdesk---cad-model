# BetterDesk CAD Models

This repository contains the CAD models and associated design files for **BetterDesk**, a custom desk model. Due to the complexity and size of the model, it is not practical to directly upload the complete raw STL, F3D, or other parametric CAD files directly to GitHub.

Instead, the repository includes the original model data archive and an automated conversion workflow that allows you to generate the CAD model locally on your computer.

---

## How to Generate the STEP Model

###  On Windows
1. Ensure [7-Zip](https://www.7-zip.org/) is installed on your computer.
2. Open the `table_stl_to_step` folder.
3. Double-click `convert_table.bat`.
4. The script will set up the environment, extract the model, and convert it to STEP format.

###  On macOS
1. Install **7-Zip** via Homebrew (if not already installed):
   ```bash
   brew install sevenzip
   ```
2. Open Terminal, navigate to the `table_stl_to_step` folder, make the script executable, and run it:
   ```bash
   cd table_stl_to_step
   chmod +x convert_table.sh
   ./convert_table.sh
   ```
###  On Linux
1. In terminal, open the the `table_stl_to_step` folder.
2. ```bash
   chmod +x linux_stl_to_step.sh
   ```
3. ```bash
   ./linux_stl_to_step.sh
   ```
4. The script will set up the environment, extract the model, and convert it to STEP format.
p.s this has only been tested on kubuntu lts 24
---

##  Conversion Time

 **This process may take a LOTTTTTT of time (often 15-30 minutes or more depending on your computer's CPU speed).**

The desk assembly contains over **1,500 individual solid bodies** and **~260,000 faces**. The automated OpenCASCADE geometry repair, topology validation and STEP serialization phases are heavily CPU-intensive. 

Please keep your terminal or command prompt open and allow the process to finish until the `SUCCESS` message is displayed.

It also has a tendency to crash, especially on the linux version if you are using a low end computer without a dedicated gpu.
---

## Output Files

Once the conversion is complete, the generated files will be available in the `table_stl_to_step/output` folder:
- **`final_table_1-5m.step`**: The complete 3D STEP assembly model. Can be opened in CAD software such as Autodesk Fusion 360, FreeCAD, SolidWorks, Rhino, Onshape, or Blender.
- **`final_table_1-5m.png`**: A 2D rendered preview image of the table.

The conversion is performed 100% locally on your machine. An internet connection is only needed on the very first run to download the required CAD libraries.

---

## Attribution & Licenses

This conversion workflow uses the open-source **2STEP Converter** project by YaneonY. The conversion software, including its underlying OpenCASCADE-based conversion pipeline and associated code, is the work of the original project authors. This repository does not claim ownership of the 2STEP Converter software.

* 2STEP Converter: https://github.com/yaneony/2STEP-Converter.git
* The original 2STEP Converter license and attribution are included in the `table_stl_to_step/2STEP-Converter` directory.
