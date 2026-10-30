## To create new images using InkScape (i.e., svg)
1. Open Inkscape
1. Copy the template from the desired folder (e.g., Icons/template.svg) and give it a new name (e.g., myImage.svg)
1. open myImage.svg and create image
1. To generate png, do one of the following into the correct folder

- For **single** .svg either save from Inkscape or from terminal (linux)

        inkscape -d 300 -e myImage.png myImage.svg
	
- For **all** .svg save using terminal (linux)
	
	    for file in *.svg; do inkscape $file -e ${file%svg}png; done

**Note 1:** Inkscape does not support jpg. A thirdparty program can be used to convert if desired.
	
## To create new images using PowerPoint

1. Open the appropriate *.pptm
1. New Slide > Title Slide
1. Where it says **Click to add title** add a title for the image. This will be the file name of the generated image.
1. Create your new image.
1. Click the View > Macros > ExportSlidesAsJPG
1. A dialog prompt will appear. Pressing **OK** will generate a folder with the name of the .pptm and overwrite all images in the folder.

- E.g., Icons.pptm generates an Icons folder

**Note 1:** To change the resolution, edit the macro (Alt+F11).
   
    oSlide.Export folderPath & "\" & sImageName, "JPG", ScaleWidth, ScaleHeight

**Note 2:** If you have open more than one *.pptm with the macro, running the macro will default to macro associated with the most recently opened .pptm.