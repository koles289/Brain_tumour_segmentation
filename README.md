# Bacherlor thesis <br> Application Of Optimisation Methods For Mri Data Segmentation
Date 25.05.2018 
This thesis deals with a segmentation of brain tissues from MRI image data and its implementation in MATLAB. <br>
Segmentation problematic is described with attention to formulating segmentation as optimization problem and segmentation of given images with different metaheuristic algorithm consequently. This approach was chosen due to information from last specialized publications, where it was accentuated for its fast computational speed and universality. This thesis tries to prove this statement with segmentation of brain images with brain tumours that have different types, number, stage of illness and phase of therapy. <br>

For more information check this paper https://dspace.vutbr.cz/xmlui/handle/11012/138153 <br> or whole thesis on my university page https://www.vutbr.cz/studenti/zav-prace/detail/110519?zp_id=110519

<br>Achieved result:<br>

<img src="https://github.com/koles289/Brain_tumour_segmentation/blob/master/Segmentation_output.png" width="700"> 

<br>Manual:<br>
The program start runnig using script <i>main.m</i>. It is required to set some variables as path to images in BRATS folder: variable <i>nac_obrazy</i>. Algorithm is able to load only images in <i>.mha</i> format. You can select the the image from BRATS folder that you want t segment, you can choose the metaheuristic algorithm (FA, SSO or hybrid FASSO) and the segmentation algorithm (2D or 3D). Default setting is to image HG0015 using 3D segmentation and FASSO algorithm.<br> 
Output of the program is the JACCARD score and visualization of segmented image.<br> 
As we talk about metaheuristic algorithm, user can select  the most basic optimalization algorithm paraneters too..<br>

Example of flowchart for 3D segmentation<br>
<img src="https://github.com/koles289/Brain_tumour_segmentation/blob/master/3D_segmentation_flowchart.png" width="400">



