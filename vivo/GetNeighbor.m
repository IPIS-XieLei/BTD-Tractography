function MatrixNeighbor = GetNeighbor(N,F)
if F==1
[x,y,z] = meshgrid(-N:N,-N:N,-N:N);
MatrixNeighbor = [x(:),y(:),z(:)];
else
[x,y,z] = meshgrid(-N:N,-N:N,0);
MatrixNeighbor = [x(:),y(:),z(:)];
end

end