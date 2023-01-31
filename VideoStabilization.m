close all
clear all

fprintf('starting job\n');

videoFile = 'palla_rotolante.mkv';

vid = VideoReader(videoFile);
implay(videoFile)


nFrames = vid.NumFrames;

firstFrame = vid.readFrame();
[height,width,~] = size(firstFrame);

frames(:,:,:,1) = firstFrame;
for i = 2:nFrames
        frames(:,:,:,i) = vid.readFrame();   
end
    
if width > 480 && height > 480 && nFrames > 60
    for i = 1:size(frames,4)
        sub(:,:,:,i) = imresize(frames(:,:,:,i),480/height);
    end
    frames = sub;
end

%%



%%

template = imcrop(frames(:,:,:,2));

template_gray = rgb2gray(template);
[theight,twidth] = size(template);


best_ccs={};

maxHeight = 0;
maxWidth = 0;


bestAngle=0;
lastBestAngle = 0;
tiltDirection = 0;
tiltRange = 40;

bestAngles = zeros;

for i = 1:size(frames,4)
    frame = frames(:,:,:,i);
    frame_gray = rgb2gray(frame);

    L = zeros;

    
    i 
    tiltRange
    tiltDirection
    
    from = -round(tiltRange/2 ) + round(tiltDirection/4);
    to = round(tiltRange/2 ) + round(tiltDirection/4);
    
    for angle = from : to
           
        curr_angle = lastBestAngle+angle;
        frame_rotated = imrotate(frame_gray, curr_angle,'loose');
        cc = normxcorr2(template_gray, frame_rotated);
        tempL = max(cc(:));
        
        if tempL > L
            bestAngle = curr_angle;
            L = tempL;
            best_cc = cc;
            best_img = frame_rotated;
        end
        
 
    end
    
    imshow(imrotate(frame_gray, bestAngle,'loose'))
    
    tiltDirection = bestAngle - lastBestAngle;
    lastBestAngle = bestAngle;
    
    if tiltDirection >= tiltRange*3/8
        tiltRange = 2 * tiltRange;
    elseif  tiltDirection >= tiltRange/4
        tiltRange = tiltRange + tiltRange/2;
    elseif  tiltDirection < tiltRange/4 && tiltRange >= 10
        tiltRange = tiltRange - tiltRange/7;
    end
        
    
    [height,width,~] = size(best_img);
    
    if maxHeight < height
        maxHeight = height;
    end
    
    if maxWidth < width
        maxWidth = width;
    end
    
    best_ccs{i}= best_cc;
    bestAngles(i) = bestAngle;

end





%%
for i=1:size(frames,4)
    i
    
    best_cc = best_ccs{i};
    bestAngle = bestAngles(i);
    
    rotatedFrame = imrotate(frames(:,:,:,i), bestAngle, 'loose');

    [height,width,~] = size(rotatedFrame);
    
    
    [max_cc, imax] = max(best_cc(:));
    [ypeak, xpeak] = ind2sub(size(best_cc),imax(1));
    ypeak = ypeak + (maxHeight - height)/2;
    xpeak = xpeak + (maxWidth - width)/2;

    corr_offset = [(ypeak-maxHeight) (xpeak-maxWidth)];

    
    paddedImage = padarray(rotatedFrame, [floor((maxHeight-height)/2) floor((maxWidth-width)/2)], 0,'post');
    paddedImage = padarray(paddedImage, [ceil((maxHeight-height)/2) ceil((maxWidth-width)/2)], 0,'pre');


     traslatedFrame = imtranslate(paddedImage,[-(corr_offset(2)+round(maxWidth/2)),...
          -(corr_offset(1)+round(maxHeight/2))],'FillValues',0);
      
    imshow(traslatedFrame)
    new(:,:,:,i) = traslatedFrame;
end 

%%


vidObj = VideoWriter('stabilized_video_montage');
open(vidObj);
figure;
for i=1:size(new,4)
    subplot(121); imshow(frames(:,:,:,i));
    subplot(122); imshow(new(:,:,:,i));
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame); 
end 
close(vidObj);
%%

vidObj = VideoWriter('stabilized_video');
open(vidObj);
for i=1:size(new,4)
    imshow(new(:,:,:,i));
    writeVideo(vidObj,new(:,:,:,i)); 
end 
close(vidObj);



fprintf('job done \n');