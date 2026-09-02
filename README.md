# CAD Model Archive

## Overview

This repository contains the CAD models and associated design files for a custom desk project.

The desk was designed using Autodesk Fusion and consists of multiple individual Fusion design files representing different components and assemblies of the overall desk. The models contain the geometry, sketches, construction features, joints, parameters, and other native Fusion design information used during development.

The purpose of this archive is to preserve the original CAD work and make the complete design available for reference, further development, manufacturing, or modification.

## Project Structure

The desk is not represented by a single standalone CAD file. The overall project consists of multiple Fusion designs stored within an Autodesk Fusion cloud project.

The individual designs may represent different parts or assemblies of the desk, including structural components, panels, brackets, supports, mechanical components, and other custom-designed elements.

Because the designs are linked within a Fusion cloud project, some components may contain references to other Fusion designs. These relationships are important to preserving the original assembly structure and design intent.

## Autodesk Fusion Format

The original models were created in Autodesk Fusion using its native cloud-based project system.

Under normal circumstances, individual Fusion designs can be exported as Autodesk Fusion Archive (`.f3d`) files. For designs containing externally referenced components or distributed designs, Fusion may instead use the Autodesk Fusion Distributed Design format (`.f3z`).

The `.f3d` format is preferred for individual Fusion designs because it preserves the native Fusion design information in a form that can be opened directly in Fusion.

## Export Issue

At the time of preparing this archive, I am unable to export the individual designs in the project directly to `.f3d` files.

The issue appears to be related to Autodesk Fusion's current cloud-project download/export restrictions rather than the CAD models themselves.

The models are present and accessible within the Fusion cloud project, but the available web interface does not provide the option to download the individual native Fusion design files without an eligible paid Fusion subscription.

Instead, the available download option provides a **Fusion Cloud Archive**.

The Cloud Archive is not simply a ZIP file containing the individual `.f3d` files. Consequently, it cannot be treated as a normal archive that can be opened and extracted to recover the original `.f3d` files.

### Why the `.f3d` Files Are Not Included

The absence of individual `.f3d` files in this archive does **not** mean that the CAD models were never created or that the models are missing.

The original designs remain stored in Autodesk Fusion's cloud project.

The problem is specifically the inability to perform the required native-file export/download operation under the current account and licensing restrictions.

In other words:

* The CAD models exist.
* The models were created natively in Autodesk Fusion.
* The models are stored in a Fusion cloud project.
* The project contains multiple Fusion design files.
* The individual native designs cannot currently be downloaded as `.f3d` files through the available account.
* Fusion instead provides a Cloud Archive download.
* The Cloud Archive does not directly expose the individual `.f3d` files.
* Therefore, the individual `.f3d` files cannot currently be included in this repository.

## This Is Not a CAD Conversion Issue

It is important to distinguish this from a CAD-format conversion problem.

The models do not need to be converted from another CAD format into Fusion.

They were originally created in Fusion itself.

The problem occurs when attempting to retrieve the native Fusion files from Autodesk's cloud storage.

Converting the models through an intermediate format such as STL, STEP, or OBJ would also not be equivalent to exporting the original `.f3d` files.

Those formats primarily preserve the resulting geometry and do not preserve the complete native Fusion design history.

For example, a STEP file can preserve the solid geometry and assembly information to varying degrees, but it does not reproduce the original Fusion feature tree, sketches, parameters, construction geometry, timeline, or other Fusion-specific design information.

For this reason, obtaining the original `.f3d` files is important when preservation of the editable Fusion design is required.

## Intended Future Export

Once access to the required Fusion export functionality is available, the individual designs can be exported from the cloud project as native Fusion Archive files.

The expected workflow is:

1. Open the Autodesk Fusion cloud project.
2. Locate the individual desk design.
3. Open or select the required Fusion design.
4. Use Fusion's native export/download functionality.
5. Export the design as an Autodesk Fusion Archive (`.f3d`).
6. Repeat the process for the remaining individual designs.
7. Preserve the resulting `.f3d` files alongside this README.

If a distributed design requires an `.f3z` archive, the `.f3z` should also be retained because it can preserve the relationships between the associated Fusion designs.

## Preservation Notes

The cloud project should be considered the **current authoritative source** for the original CAD designs until the individual native Fusion files have been successfully exported.

The files in this repository should therefore not be interpreted as a complete replacement for the original Fusion cloud project.

In particular, deleting or modifying the Fusion cloud project before successfully exporting the native designs could result in the loss of design information that is not present in exported geometry-only formats.

The original Fusion project should be retained until a verified local archive of all required native designs has been created.

## Desk Design

The CAD project represents a custom desk designed as a multi-component assembly.

The purpose of maintaining the CAD files is to provide a complete digital representation of the desk prior to physical fabrication. The models can be used for:

* Dimensional verification
* Component manufacturing
* 3D printing of smaller components
* CNC or other fabrication processes
* Assembly planning
* Interference checking
* Design modification
* Future revisions
* Documentation
* Archival purposes

The use of separate Fusion designs allows individual components to be developed and modified without requiring the entire desk to be represented by a single monolithic model.

## File Format Requirements

For long-term preservation, the preferred hierarchy is:

1. **`.f3d`** - Individual native Autodesk Fusion design
2. **`.f3z`** - Fusion distributed design containing associated native designs
3. **STEP (`.step` / `.stp`)** - Interoperable CAD geometry backup
4. **STL (`.stl`)** - Mesh/3D-printing representation

The first two formats are preferred when preserving the editable Fusion design.

STEP and STL files should be considered secondary geometry backups rather than replacements for the native Fusion files.

## Current Status

**CAD design:** Complete / stored in Autodesk Fusion cloud
**Project type:** Multi-file Autodesk Fusion cloud project
**Native CAD system:** Autodesk Fusion
**Individual `.f3d` export:** Currently unavailable through the available account
**Cloud Archive:** Available
**Individual native files in this repository:** Not currently available
**Reason:** Autodesk Fusion cloud download/export restriction

## Important Disclaimer

This README documents the current state of the project and the reason individual `.f3d` files are not included.

The inability to provide the `.f3d` files is an export/access limitation and should not be interpreted as an indication that the underlying CAD models are incomplete, corrupted, or unavailable in the original Fusion project.

The original cloud project remains the source from which the native CAD files should eventually be exported.

Once the export restriction has been resolved, this repository should be updated with the corresponding `.f3d` files and, where applicable, `.f3z` distributed-design archives.

## Summary

This repository contains documentation and available files for a multi-file CAD project representing a custom desk.

The original designs were created natively in Autodesk Fusion and remain stored in a Fusion cloud project. However, the current account does not provide access to the required individual native-file download/export functionality. Fusion currently provides a Cloud Archive instead, but that archive does not contain the individual `.f3d` files in an directly extractable form.

As a result, the original native Fusion files cannot currently be included here.

The models themselves are not lost. The limitation is specifically the ability to export the native files from Autodesk's cloud environment.

The `.f3d` files should be added to this repository once the appropriate Fusion export functionality becomes available.
