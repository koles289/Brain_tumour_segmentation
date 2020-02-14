%% sphere
function [koule] = sphere(r)
v1 = -r;
v2 = r;

[x,y,z] = meshgrid(v1:v2,v1:v2,v1:v2);

koule = zeros(size(x));

koule( x.^2 + y.^2 + z.^2 <= r^2)=1;

