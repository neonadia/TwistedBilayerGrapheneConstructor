close all
clear;clc;

base1 = [6.168519;-2.136838];
base2 = [-1.233704;6.410513];

v_x = base1(1);
v_y = base1(2);

num_of_atom = 28; %need to specify the num of atoms in the origin file
%num_of_atom_new = 28;

filename='unitcell_unrotate21.vasp'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%f %f %f',num_of_atom);

%w=1.5; %initial posiztion, need to adjust so that
             %the num of atoms is correct

cos = v_x/sqrt(v_x^2 + v_y^2);
sin = sqrt(1-cos^2);

rot_m = [cos -sin; sin cos]; 


new_base1 = inv(rot_m)*base1;
new_base2 = inv(rot_m)*base2;




filename2 = 'un21_norm.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'13_rotated_graphene\n')
fprintf(fid,'1.0\n')
fprintf(fid,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),0);
fprintf(fid,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),0);
fprintf(fid,'\t%f\t %f\t %f\n',0,0,15);
fprintf(fid,'\tC\n')
fprintf(fid,'\t%i\n',num_of_atom);
fprintf(fid,'Cartesian\n')



for i = 1:num_of_atom 
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    if d(i,3) >0
        e = [c{1,1}(i) ; c{1,2}(i)];
        f =inv(rot_m)*e; %clockwise rotation
        fprintf(fid,'\t%f\t %f\t %f\n',f(1),f(2),3.34995);
    end
    
    if d(i,3) ==0
        g = [c{1,1}(i) ; c{1,2}(i)];
        h =inv(rot_m)*g; %clockwise rotation
        fprintf(fid,'\t%f\t %f\t %f\n',h(1),h(2),0);
    end
end


fclose(fid)