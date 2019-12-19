close all
clear;clc;

num_of_atom = 1016;
sup_x = 3;
sup_z = 20;

num_of_atom_new = num_of_atom * sup_x * sup_z;

base1 = [32.0762977600,0,0];  % need to adjust according to the lattice vector in the origin file
base2 = [0,55.5577774048,0];

new_base1 = base1 * sup_x; % supercell
new_base2 = base2 * sup_z;
new_base3 = [0,0,6.9543900490];

filename='unitcell4_rec_fine'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

filename2 = 'AB4-3-100.vasp';
fid2=fopen(filename2,'w')
fprintf(fid2,'4.40_rotated_graphene\n')
fprintf(fid2,'1.0\n')
fprintf(fid2,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base3(1),new_base3(2),new_base3(3));
fprintf(fid2,'\tC\n')
fprintf(fid2,'\t%i\n',num_of_atom_new);
fprintf(fid2,'Cartesian\n')


for i = 1:sup_x
    for j = 1:sup_z
        for k = 1:num_of_atom
            fprintf(fid2,'\t%f\t %f\t %f\n',c{1,1}(k)+(i-1)*base1(1),c{1,2}(k)+(j-1)*base2(2),c{1,3}(k));
        end
    end
end

filename3 = 'data.AB4-3-100';
fid3=fopen(filename3,'w')
fprintf(fid3,'# 4.40 Twisted Bilayer Graphene cell with dimension 3 x 20 x 1\n')
fprintf(fid3,'\t\t %i \t %s\n',num_of_atom_new,'atoms');
fprintf(fid3,'\t\t %i \t %s\n\n',2,'atom types');
fprintf(fid3,'\t%f\t %f\t %s\n',0,new_base1(1),'xlo xhi');
fprintf(fid3,'\t%f\t %f\t %s\n',-15,15,'ylo yhi');
fprintf(fid3,'\t%f\t %f\t %s\n\n',0,new_base2(2),'zlo zhi');
fprintf(fid3,'Masses\n\n')
fprintf(fid3,'\t%i \t %f \n',1,12.0107);
fprintf(fid3,'\t%i \t %f \n\n',2,12.0107);
fprintf(fid3,'Atoms\n\n')

nnn = 0;

for i = 1:sup_x
    for j = 1:sup_z
        for k = 1:num_of_atom
            nnn = nnn + 1;
            if c{1,3}(k) > 3
                fprintf(fid3,'%i\t %s\t \t%f\t %f\t %f\n',nnn,'1',c{1,1}(k)+(i-1)*base1(1),c{1,3}(k),c{1,2}(k)+(j-1)*base2(2));
            end
            if c{1,3}(k) < 3
                fprintf(fid3,'%i\t %s\t \t%f\t %f\t %f\n',nnn,'2',c{1,1}(k)+(i-1)*base1(1),c{1,3}(k),c{1,2}(k)+(j-1)*base2(2));
            end
        end
    end
end

fclose(fid)
            
    