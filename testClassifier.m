function testClassifier(options)

% Parse input
if isfield(options, 'vid')
    vid = options.vid;
else
    vid = videoinput('winvideo',1,'YUY2_640X480');
    %vid = videoinput('winvideo',2,'MJPG_640x480');
end

detector = options.detector;

% Put the video trigger into 'manual', this starts streaming the video
% without saving it. We can then request frames at will while only having
% to run the startup overhead this one time.
triggerconfig(vid,'manual');
start(vid)

% Initialize frame counter and fps variable
counter = 1;
fps = 0;

% Set the total runtime in seconds 
runtime = 180;

% Initialize figure to display video
h = figure(1);

% Start the timer and start keeping track of the time at the beginning of
% every 10 frames
tic
timeTracker = toc;

% We run a while loop to get and display a frame from the camera. The while
% loop runs for <runtime> seconds.
while toc < runtime 
  % Compute the frame rate averaged over the last 10 frames
   if counter==10
       counter = 0;
       fps = 10/(toc-timeTracker);
       timeTracker = toc;
   end
   counter = counter + 1;

   % Get a new frame from the camera
   img = getsnapshot(vid);

   % Detect user-defined object
   bbox = step(detector, img);
   
   % Label detected objects
   detectedImg = insertShape(img, 'rectangle', bbox,'Color', [255 0 0]);
   
   % Display image
   %    Note: use imagesc() instead of imshow() (it's faster).
   imagesc(detectedImg); axis off
   title(['FPS: ' sprintf('%2.1f', fps)]); drawnow
   
end



% Stop the video stream
stop(vid)
end