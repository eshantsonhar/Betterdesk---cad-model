# BetterDesk CAD Models

This repository contains the CAD models and associated design files for BetterDesk, a custom desk model. Due to the complexity and size of the model, it is not practical to directly upload the complete STL, F3D, or other parametric CAD files to the repository.

Instead, the repository includes the original model data and an automated conversion workflow that allows you to generate the CAD model locally.

To obtain the STEP model, download the contents of this repository and open the `table_stl_to_step` folder. Double-click `convert_table.bat`. The script will automatically extract the model and convert it into a STEP file on your computer. Once the process is complete, the generated file will be available in the `output` folder and can be opened in CAD software such as Autodesk Fusion, FreeCAD, SolidWorks, or Rhino.

The conversion is performed locally on your computer, so the model does not need to be uploaded to an external service. The initial setup may require an internet connection to download the required dependencies.

This conversion workflow uses the open-source 2STEP Converter project by YaneonY. The conversion software, including its underlying OpenCASCADE-based conversion pipeline and associated code, is the work of the original project authors. This repository does not claim ownership of the 2STEP Converter software.

2STEP Converter: https://github.com/yaneony/2STEP-Converter.git

The original 2STEP Converter license and attribution are included in the `2STEP-Converter` directory.
