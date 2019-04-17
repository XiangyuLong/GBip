function allcoords = gbip_create_cube(centervoxel,vradius)

% ach_create_cube(centervoxel,vradius)
% radius is the number of voxels

centerx = centervoxel(1);
centery = centervoxel(2);
centerz = centervoxel(3);

allcoords = [];
for i = centerx-vradius : centerx+vradius
    for j = centery-vradius : centery+vradius
        for k = centerz-vradius : centerz+vradius
            allcoords = [allcoords;i,j,k];
        end
    end
end
