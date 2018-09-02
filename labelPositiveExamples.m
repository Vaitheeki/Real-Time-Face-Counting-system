function varargout = labelPositiveExamples(options)
% This function goes through a directory of images and labels objects in
% each image. This process can either be done autonomously using a
% pre-trained classifier or manually using the Matlab function
% CascadeTrainGUI. The output of this function is a struct array with 
% fields:
%   imageFilename           - Filename of image
%   objectBoundingBoxes     - Bounding boxes for objects in image
% 
% There is one input struct, options, which is the output of
% takeSnapshots.m. Additionally, there are the following fields which can
% be added/modified:
%   usePretrainedObjectDetector - [boolean] 
%       If set to true objects will automatically be found using the
%       pretrained detector set by options.detector. If set to false 
%       CascadeTrainGUI (can be found on MatlabCentral) will be called to 
%       label all images by hand. See the example training file for proper 
%       steps and calling sequences. Default = true;
%   detector - [vision.CascadeObjectDetector] 
%       Detector to use if options.usePretrainedObjectDetector is set to 
%       true. By default 'FrontalFaceCART' will be used. Refer to 'help
%       vision.CascadeObjectDetector' for help passing in other detectors.

%% Parse input
if nargin ~= 1
    warning('This function requires exactly one input!')
    return

else
    % Options that should always be there
    numImgs = options.numImgs;
    filename = options.filename;
    
    % Detector options
    if isfield(options, 'usePretrainedObjectDetector')
        usePOD = options.usePretrainedObjectDetector;
    else
        usePOD = true;
    end
    
    if usePOD && isfield(options, 'detector')
        detector = options.detector;
    elseif usePOD
        detector = vision.CascadeObjectDetector('FrontalFaceCART');
    end
    
end


%% Label objects

% Compute the string format that was used for saving images
strFormat = ['%0' num2str(ceil(log10(numImgs))) 'd']; 

% Label object autonomously if desired
if usePOD
    figure
    curImg = 1;
    for R = 0:numImgs-1 
        % Load image 
        fullFilename = [filename 'Image_' sprintf(strFormat, R) '.jpg'];
        img = imread(fullFilename);
       
        % Detect faces
        bbox = step(detector, img);
       
        % Save results
        if numel(bbox)==4
            data(curImg).imageFilename = fullFilename;
            data(curImg).objectBoundingBoxes = bbox;
            
            curImg = curImg + 1;
        end
        
        % Display results
        detectedImg = insertShape(img, 'rectangle', bbox, 'Color', [255 0 0]);
        imagesc(detectedImg); axis off
        title(['Labeling Images: ' num2str(R+1) '/' num2str(numImgs)]); 
        drawnow
    end
   
    % Save results
    save([filename 'data.mat'], 'data');

else
    % Else label objects manually
    CascadeTrainGUI
    
    % Save results
    save(filename, 'data');
    
end

% Return data if desired
if nargout == 1
    varargout{1} = data;
end

end
