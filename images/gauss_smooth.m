% Applies Gaussian smoothing to a (multidimensional) image.
%
% Smooths the n-dimensional array I with a n-dimensional gaussian with
% standard deviations specified by sigmas.  This operation in linearly
% seperable and is implemented as such.
%
% USAGE
%  [L,filters] = gauss_smooth( I, sigmas, [shape], [radius] )
%
% INPUTS
%  I       - input image
%  sigmas  - either n dimensional or 1 dimensional vector of standard devs
%            if sigmas(n)<=.3 then does not smooth along that dimension
%  shape   - ['full'] shape flag 'valid', 'full', 'same', or 'smooth'
%  radius  - [2.25] radius in units of standard deviation
%
% OUTPUTS
%  L       - smoothed image
%  filters - actual filters used, cell array of length n
%
% EXAMPLE
%  h = histc_1D( randn(2000,1), 20 );
%  histmontage([h; h]);
%
% See also

% Piotr's Image&Video Toolbox      Version 1.5
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function [L,filters] = gauss_smooth( I, sigmas, shape, radius )

nd = ndims(I);  if(length(sigmas)==1); sigmas=repmat(sigmas,[1,nd]); end
if( nd > length(sigmas)); error('Incorrect # of simgas specified'); end
sigmas = sigmas(1:nd);

if( isa( I, 'uint8' ) ); I = double(I); end
if( nargin<3 || isempty(shape) ); shape='full'; end
if( nargin<4 || isempty(radius) ); radius=2.25; end

% create and apply 1D gaussian masks along each dimension
L = I;  filters = cell(1,nd);
for i=1:nd
  if (sigmas(i)>.3)
    r = ceil( sigmas(i)*radius );
    f = filter_gauss_1D( r, sigmas(i) );
    f = permute( f, circshift(1:nd,[1,i-1]) );
    filters{i} = f;
    L = convn_fast( L, f, shape );
  else
    filters{i} = 1;
  end
end

