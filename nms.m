function [eout,thresh] = nms(varargin)
%canny:Find edges in intensity image.
%canny takes an intensity image I as its input, and returns a binary image
% BW of the same size as I, with 1's where the function finds edges in I
% and 0's elsewhere.
%
%
%
% The Canny method finds edges by looking for local maxima of the
% gradient of I. The gradient is calculated using the derivative of a
% Gaussian filter. The method uses two thresholds, to detect strong
% and weak edges, and includes the weak edges in the output only if
% they are connected to strong edges. This method is therefore less
% likely than the others to be "fooled" by noise, and more likely to
% detect true weak edges.
%
%
% Canny Method
% ----------------------------
% BW = canny(I) specifies the Canny method.
%
% BW = canny(I,THRESH) specifies sensitivity thresholds for the
% Canny method. THRESH is a two-element vector in which the first element
% is the low threshold, and the second element is the high threshold. If
% you specify a scalar for THRESH, this value is used for the high
% threshold and 0.4*THRESH is used for the low threshold. If you do not
% specify THRESH, or if THRESH is empty ([]), EDGE chooses low and high
% values automatically.
%
% BW = canny(I,THRESH,SIGMA) specifies the Canny method, using
% SIGMA as the standard deviation of the Gaussian filter. The default
% SIGMA is 1; the size of the filter is chosen automatically, based
% on SIGMA.
%
% [BW,thresh] = canny(I,...) returns the threshold values as a
% two-element vector.
%
% Class Support
% -------------
% I can be of class uint8, uint16, or double. BW is of class uint8.
%
% Example
% -------
% Find the edges of the rice.tif image using the Prewitt and Canny
% methods:
%
% I = imread('rice.tif');
% BW2 = canny(I);
%
% Clay M. Thompson 10-8-92
% Revised by Chris Griffin, 1996,1997
% Copyright 1993-1998 The MathWorks, Inc. All Rights Reserved.
% $Revision: 5.14 $ $Date: 1998/12/17 17:20:14 $

adjustParam = 1.0;

% ?????? --> ???????????
[a,thresh,sigma,H,kx,ky] = parse_inputs(varargin{:});

% %?????????

if isa(a, 'uint8') | isa(a, 'uint16')
a = im2double(a);
end

m = size(a,1); 
n = size(a,2); 

rr = 2:m-1; cc=2:n-1; 

% ??? m*n ??????0
e = repmat(logical(uint8(0)), m, n);

% Magic numbers ?????

GaussianDieOff = .0001;
PercentOfPixelsNotEdges = .5; % Used for selecting thresholds
ThresholdRatio = .5; % Low thresh is this fraction of the high.

% Design the filters - a gaussian and its derivative


% ???????--?????????? ????? gau,dgau??
pw = 1:30; % possible widths
ssq = sigma*sigma;
width = max(find(exp(-(pw.*pw)/(2*sigma*sigma))>GaussianDieOff));
if isempty(width)
width = 1; % the user entered a really small sigma
end
t = (-width:width);
len = 2*width+1;
t3 = [t-.5; t; t+.5]; % We will average values at t-.5, t, t+.5
gau = sum(exp(-(t3.*t3)/(2*ssq))).'/(6*pi*ssq); % the gaussian 1-d filter
dgau = (-t.* exp(-(t.*t)/(2*ssq))/ ssq).'; % derivative of a gaussian



% Convolve the filters with the image in each direction
% The canny edge detector first requires convolutions with
% the gaussian, and then with the derivitave of a gauusian.
% I convolve the filters first and then make a call to conv2
% to do the convolution down each column.

ra = size(a,1);
ca = size(a,2);
ay = 255*a;
ax = 255*a';

h = conv(gau,dgau); %???????
ax = conv2(ax, h, 'same').';
ay = conv2(ay, h, 'same');
%mag = sqrt((ax.*ax) + (ay.*ay));
mag = double(a);
magmax = max(mag(:));
if magmax>0
mag = mag / magmax; % normalize
end

% Select the thresholds ????
if isempty(thresh)
[counts,x]=imhist(mag, 64);
highThresh = min(find(cumsum(counts) > PercentOfPixelsNotEdges*m*n)) / 64;
highThresh = adjustParam * highThresh;
lowThresh = ThresholdRatio*highThresh;
thresh = [lowThresh highThresh];
elseif length(thresh)==1
highThresh = thresh;
if thresh>=1
error('The threshold must be less than 1.');
end
lowThresh = ThresholdRatio*thresh;
thresh = [lowThresh highThresh];
elseif length(thresh)==2
lowThresh = thresh(1);
highThresh = thresh(2);
if (lowThresh >= highThresh) | (highThresh >= 1)
error('Thresh must be [low high], where low < high < 1.');
end
end

% The next step is to do the non-maximum supression.
% We will accrue indices which specify ON pixels in strong edgemap
% The array e will become the weak edge map.
idxStrong = [];
for dir = 1:4
idxLocalMax = cannyFindLocalMaxima(dir,ax,ay,mag); %??????
idxWeak = idxLocalMax(mag(idxLocalMax) > lowThresh);
e(idxWeak)=1;
idxStrong = [idxStrong; idxWeak(mag(idxWeak) > highThresh)];
end

rstrong = rem(idxStrong-1, m)+1;
cstrong = floor((idxStrong-1)/m)+1;
e = bwselect(e, cstrong, rstrong, 8);

e = bwmorph(e, 'bridge',2);
%e = bwmorph(e, 'dilate');
%e = bwmorph(e, 'bridge');
%e = bwmorph(e, 'thin',3);
%e = bwmorph(e, 'bridge');

if nargout==0,
imshow(e);
else
eout = e;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Local Function : cannyFindLocalMaxima
% ?????????????????????
function idxLocalMax = cannyFindLocalMaxima(direction,ix,iy,mag);
%
% This sub-function helps with the non-maximum supression in the Canny
% edge detector. The input parameters are:
%
% direction - the index of which direction the gradient is pointing, ??
% read from the diagram below. direction is 1, 2, 3, or 4.
% ix - input image filtered by derivative of gaussian along x
% iy - input image filtered by derivative of gaussian along y
% mag - the gradient magnitude image ????
%
% there are 4 cases:
%
% The X marks the pixel in question, and each
% 3 2 of the quadrants for the gradient vector
% O----0----0 fall into two cases, divided by the 45
% 4 | | 1 degree line. In one case the gradient
% | | vector is more horizontal, and in the other
% O X O it is more vertical. There are eight
% | | divisions, but for the non-maximum supression
% (1)| |(4) we are only worried about 4 of them since we
% O----O----O use symmetric points about the center pixel.
% (2) (3)

[m,n,o] = size(mag);

% Find the indices of all points whose gradient (specified by the vector (ix,iy)) is going in the direction we're looking at.

% ??????????? idx ??
switch direction
case 1
idx = find((iy<=0 & ix>-iy) | (iy>=0 & ix<-iy));
case 2
idx = find((ix>0 & -iy>=ix) | (ix<0 & -iy<=ix));
case 3
idx = find((ix<=0 & ix>iy) | (ix>=0 & ix<iy));
case 4
idx = find((iy<0 & ix<=iy) | (iy>0 & ix>=iy));
end

% Exclude the exterior pixels
if ~isempty(idx)
v = mod(idx,m);
extIdx = find(v==1 | v==0 | idx<=m | (idx>(n-1)*m));
idx(extIdx) = [];
end

ixv = ix(idx);
iyv = iy(idx);
gradmag = mag(idx);

% Do the linear interpolations for the interior pixels
switch direction
case 1
d = abs(iyv./ixv);
gradmag1 = mag(idx+m).*(1-d) + mag(idx+m-1).*d;
gradmag2 = mag(idx-m).*(1-d) + mag(idx-m+1).*d;
case 2
d = abs(ixv./iyv);
gradmag1 = mag(idx-1).*(1-d) + mag(idx+m-1).*d;
gradmag2 = mag(idx+1).*(1-d) + mag(idx-m+1).*d;
case 3
d = abs(ixv./iyv);
gradmag1 = mag(idx-1).*(1-d) + mag(idx-m-1).*d;
gradmag2 = mag(idx+1).*(1-d) + mag(idx+m+1).*d;
case 4
d = abs(iyv./ixv);
gradmag1 = mag(idx-m).*(1-d) + mag(idx-m-1).*d;
gradmag2 = mag(idx+m).*(1-d) + mag(idx+m+1).*d;
end

idxLocalMax = idx(gradmag>=gradmag1 & gradmag>=gradmag2);

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Local Function : parse_inputs
%
function [I,Thresh,Sigma,H,kx,ky] = parse_inputs(varargin)
% OUTPUTS:
% I Image Data
% Thresh Threshold value ??
% Sigma standard deviation of Gaussian //??????????
% H Filter for Zero-crossing detection ????????????
% kx,ky From Directionality vector // ????..??????????????????????????

error(nargchk(1,4,nargin));
I = varargin{1};

% Defaults
Thresh=[];
Direction='both';
Sigma=2;
H=[];
K=[1 1];

directions = {'both','horizontal','vertical'};

% Now parse the nargin-1 remaining input arguments
% Get the rest of the arguments

Sigma = 1.0; % Default Std dev of gaussian for canny
threshSpecified = 0; % Threshold is not yet specified
nonstr=[];
for i = nonstr
if prod(size(varargin{i}))==2 & ~threshSpecified
Thresh = varargin{i};
threshSpecified = 1;
elseif prod(size(varargin{i}))==1
if ~threshSpecified
Thresh = varargin{i};
threshSpecified = 1;
else
Sigma = varargin{i};
end
elseif isempty(varargin{i}) & ~threshSpecified
% Thresh = [];
threshSpecified = 1;
else
error('Invalid input arguments');
end
end

if Sigma<=0
error('Sigma must be positive');
end

switch Direction
case 'both',
kx = K(1); ky = K(2);
case 'horizontal',
kx = 0; ky = 1; % Directionality factor
case 'vertical',
kx = 1; ky = 0; % Directionality factor
otherwise
error('Unrecognized direction string');
end
