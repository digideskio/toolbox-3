% Some post processing routines for meanshift not currently being used.
%
% USAGE
%  [IDX,C] = meanshift_post( X, IDX, C, minCsize, forceOutl )
%
% INPUTS
%  see meanshift
%
% OUTPUTS
%  see meanshift
%
% EXAMPLE

% Piotr's Image&Video Toolbox      Version 1.5
% Written and maintained by Piotr Dollar    pdollar-at-cs.ucsd.edu
% Please email me if you find bugs, or have suggestions or questions!

function [IDX,C] = meanshift_post( X, IDX, C, minCsize, forceOutl )

%%% force outliers to belong to IDX (mainly for visualization)
if( forceOutl ) 
  for i=find(IDX<0)' 
    D = dist_euclidean( X(i,:), C ); 
    [mind IDx] = min(D,[],2);  
    IDX(i) = IDx;
  end 
end; 

%%% Delete smallest cluster, reassign points, re-sort, repeat...
k = max(IDX);
ticId = ticstatus('meanshift_post',[],5); kinit = k;
while( 1 )
  % sort clusters [largest first] 
  cnts = zeros(1,k); for i=1:k; cnts(i) = sum( IDX==i ); end
  [cnts,order] = sort( -cnts ); cnts = -cnts; C = C(order,:);  
  IDX2 = IDX;  for i=1:k; IDX2(IDX==order(i))=i; end; IDX = IDX2;     

  % stop if smallest cluster is big enough
  if( cnts(k)>= minCsize ); break; end;

  % otherwise discard smallest [last] cluster
  C( end, : ) = []; 
  for i=find(IDX==k)' 
    D = dist_euclidean( X(i,:), C ); 
    [mind IDx] = min(D,[],2);  
    IDX(i) = IDx;
  end; 
  k = k-1;

  tocstatus( ticId, (kinit-k)/kinit );
end
tocstatus( ticId, 1 );
