close all
clear;clc;

num_of_atom = 56;
sup_x = 11;
sup_z = 50;

num_of_atom_new = num_of_atom * sup_x * sup_z;

base1 = [6.5194168091,0,0];  % need to adjust according to the lattice vector in the origin file
base2 = [0,11.2919616699,0];

new_base1 = base1 * sup_x; % supercell
new_base2 = base2 * sup_z;
new_base3 = [0,0,6.9543900490];

filename='ABunitcell21un_fine.vasp'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

filename2 = 'AB-11-50.vasp';
fid2=fopen(filename2,'w')
fprintf(fid2,'21_unrotated_graphene_11_50\n')
fprintf(fid2,'1.0\n')
fprintf(fid2,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base3(1),new_base3(2),new_base3(3));
fprintf(fid2,'\tC\n')
fprintf(fid2,'\t%i\n',num_of_atom_new);
fprintf(fid2,'Cartesian\n')


for j = 1:sup_z
    for i = 1:sup_x
        for k = 1:num_of_atom
            fprintf(fid2,'\t%f\t %f\t %f\n',c{1,1}(k)+(i-1)*base1(1),c{1,2}(k)+(j-1)*base2(2),c{1,3}(k));
        end
    end
end

filename3 = 'data.ABun21-11-50';
fid3=fopen(filename3,'w')
fprintf(fid3,'# AB Bilayer Graphene cell with dimension 11 x 2 x 50\n')
fprintf(fid3,'\t\t %i \t %s\n',num_of_atom_new,'atoms');
fprintf(fid3,'\t\t %i \t %s\n\n',1,'atom types');
fprintf(fid3,'\t%f\t %f\t %s\n',0,new_base1(1),'xlo xhi');
fprintf(fid3,'\t%f\t %f\t %s\n',0,6.9543900490,'ylo yhi');
fprintf(fid3,'\t%f\t %f\t %s\n\n',0,new_base2(2),'zlo zhi');
fprintf(fid3,'Masses\n\n')
fprintf(fid3,'\t%i \t %f \n\n',1,12.0107);
%fprintf(fid3,'\t%i \t %f \n\n',2,12.0107);
fprintf(fid3,'Atoms\n\n')

nnn = 0;

for j = 1:sup_z
    for i = 1:sup_x
        for k = 1:num_of_atom
            nnn = nnn + 1;
            if c{1,3}(k) > 3
                fprintf(fid3,'%i\t %s\t \t%f\t %f\t %f\n',nnn,'1',c{1,1}(k)+(i-1)*base1(1),c{1,3}(k),c{1,2}(k)+(j-1)*base2(2));
            end
            if c{1,3}(k) < 3
                fprintf(fid3,'%i\t %s\t \t%f\t %f\t %f\n',nnn,'1',c{1,1}(k)+(i-1)*base1(1),c{1,3}(k),c{1,2}(k)+(j-1)*base2(2));
            end
        end
    end
end


filename4 = 'map.ABGNR_11_50';
fid4=fopen(filename4,'w');
fprintf(fid4,'%d\t %d\t %d\t %d\n',1,1,1,num_of_atom_new);
fprintf(fid4,'Map file for 1x1x1 AB Bilayer Graphene nanoribbon cell.\n');
mmm=1;

for i = 1:num_of_atom_new    
    fprintf(fid4,'%d\t %d\t %d\t %d\t %d\n',0,0,0,mmm-1,mmm);
    mmm=mmm+1;
end

fclose(fid)
            
    