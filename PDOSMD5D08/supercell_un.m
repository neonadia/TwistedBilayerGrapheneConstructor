close all
clear;clc;

num_of_atom = 508;
sup_x = 14;
sup_y = 14;
sup_z = 0;

num_of_atom_new = num_of_atom * sup_x * sup_y;

base1 = [27.7690010071,0.0000000000,0];  % need to adjust according to the lattice vector in the origin file
base2 = [-13.8845004521,24.0486568092,0];

new_base1 = base1 * sup_x; % supercell
new_base2 = base2 * sup_y;
new_base3 = [0,0,6.4266276360];

filename='unitcellun5D08_20190130_fine.vasp'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

filename2 = 'unAB5D08-14-14.vasp';
fid2=fopen(filename2,'w')
fprintf(fid2,'un5D08_rotated_graphene\n')
fprintf(fid2,'1.0\n')
fprintf(fid2,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid2,'\t%f\t %f\t %f\n',new_base3(1),new_base3(2),new_base3(3));
fprintf(fid2,'\tC\n')
fprintf(fid2,'\t%i\n',num_of_atom_new);
fprintf(fid2,'Cartesian\n')


for i = 1:sup_x
    for j = 1:sup_y
        for k = 1:num_of_atom
            fprintf(fid2,'\t%f\t %f\t %f\n',c{1,1}(k)+(i-1)*base1(1)+(j-1)*base2(1),c{1,2}(k)+(j-1)*base2(2),c{1,3}(k));
        end
    end
end

filename3 = 'data.unAB5D08-14-14';
fid3=fopen(filename3,'w')
fprintf(fid3,'# 5D08 unrotated Bilayer Graphene cell with dimension 14 x14 x 1\n')
fprintf(fid3,'\t\t %i \t %s\n',num_of_atom_new,'atoms');
fprintf(fid3,'\t\t %i \t %s\n\n',1,'atom types');
fprintf(fid3,'\t%f\t %f\t %s\n',0,new_base1(1),'xlo xhi');
fprintf(fid3,'\t%f\t %f\t %s\n',0,new_base2(2),'ylo yhi');
fprintf(fid3,'\t%f\t %f\t %s\n',-15,15,'zlo zhi');
fprintf(fid3,'\t%f\t %f\t %f\t %s\n\n',new_base2(1),0,0,'xy xz yz');
fprintf(fid3,'Masses\n\n')
fprintf(fid3,'\t%i \t %f \n\n',1,12.0107);
fprintf(fid3,'Atoms\n\n')

nnn = 0;

for i = 1:sup_x
    for j = 1:sup_y
        for k = 1:num_of_atom
            nnn = nnn + 1;
            fprintf(fid3,'%i\t %s\t \t%f\t %f\t %f\n',nnn,'1',c{1,1}(k)+(i-1)*base1(1)+(j-1)*base2(1),c{1,2}(k)+(j-1)*base2(2),c{1,3}(k));         
        end
    end
end

filename4 = 'map.unAB5D08_14_14';
fid4=fopen(filename4,'w');
fprintf(fid4,'%d\t %d\t %d\t %d\n',sup_x,sup_y,sup_z+1,num_of_atom);
fprintf(fid4,'Map file for 14x14x1 5D08 Bilayer Graphene cell.\n');
mmm=1;
k_m = 1;

for i = 1:sup_x
    for j = 1:sup_y
        for bb = 1:num_of_atom
        if i == 1 && j ==1         
            fprintf(fid4,'%d\t %d\t %d\t %d\t %d\n',sup_z,sup_z,sup_z,bb-1,mmm);
            mmm=mmm+1;
        else
            fprintf(fid4,'%d\t %d\t %d\t %d\t %d\n',i-1,j-1,0,bb-1,mmm);
            mmm=mmm+1;
        end  
        k_m = k_m+1;
        end  
    end
end

fclose(fid)
            
    