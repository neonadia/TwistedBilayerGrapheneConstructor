clear all
%This file is made to generate the supercell of monolayer graphene
base1 = [2.4675074650, 0, 0];
base2 = [-1.2337037325,  2.1368375462,  0.0000000000];
base3 = [0,0,6.9543900490];

num_of_atom_unit_cell = 4; % might have a problem here
l = 30;%x direction
n = 30;%y direction
new_base1 = l*base1;
new_base2 = n*base2;
num_of_atom_new = num_of_atom_unit_cell * l * n;

filename='POSCAR_BLG_car.vasp';
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%f %f %f',num_of_atom_unit_cell);







k = 1;
for i = 1:l
    for j = 1:n
        for bb = 1:num_of_atom_unit_cell
        if i == 1 && j ==1
            x_space(k) = c{1,1}(k);
            y_space(k) = c{1,2}(k);
            z_space(k) = c{1,3}(k);
        else
            x_space(k) = c{1,1}(bb)+(i-1)*base1(1)+(j-1)*base2(1);
            y_space(k) = c{1,2}(bb)+(i-1)*base1(2)+(j-1)*base2(2);
             z_space(k) = c{1,3}(bb);
        end
        
        
        
        k = k+1;
        end
        
    end
end

filename2 = 'AB-BLG.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'unrotated_bilayer_graphene\n')
fprintf(fid,'1.0\n')
fprintf(fid,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid,'\t%f\t %f\t %f\n',base3(1),base3(2),base3(3));
fprintf(fid,'\tC\n')
fprintf(fid,'\t%i\n',num_of_atom_new);
fprintf(fid,'Cartesian\n')



kkk = 1;% The name of element
for i = 1:num_of_atom_new
    fprintf(fid,'\t %f\t %f\t %f\n',x_space(i),y_space(i),z_space(i));
end