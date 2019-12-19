close all
clear;clc;

num_of_atom = 100; %need to specify the num of atoms in the origin file
num_of_atom_new = 4;

filename_r1='afterrot_AABLG_20180907.xyz'; %the input of bilayer graphene supercell after rotation
fid_r1=fopen(filename_r1,'r');

for i = 1:1
    line=fgetl(fid_r1);
end

c = textscan(fid_r1,'%s %.11f %.11f %.11f',num_of_atom);



w=3; %initial posiztion, need to adjust so that
             %the num of atoms is correct
             
filename_r2='POSCAR_BLG.vasp'; %the input of graphene unitcell
fid_r2=fopen(filename_r2,'r');

for i = 1:2
    line=fgetl(fid_r2);
end

vector = textscan(fid_r2,'%.16f %.16f %.16f',3);

new_base1=[vector{1,1}(1),vector{1,2}(1),vector{1,3}(1)]; % this equation is from ref
new_base2=[vector{1,1}(2),vector{1,2}(2),vector{1,3}(2)];
new_base3=[vector{1,1}(3),vector{1,2}(3),vector{1,3}(3)];

%vect1= [norm(new_base1), 0, 0];
%vect2= [norm(new_base1)/2, sqrt(3)/2*norm(new_base1), 0];
vect1 = new_base1;
vect2 = new_base2;
vect3= -vect1;
vect4= -vect2;

p1=[w,2.5*w,c{1,4}(100)]; %end points of unit cell on layer 1
p2= p1 + vect1;
p3= p2 + vect2;
p4= p3 + vect3;

p5=[w,2.5*w,c{1,4}(1)]; %end points of unit cell on layer 2
p6= p5 + vect1;
p7= p6 + vect2;
p8= p7 + vect3;





filename2 = 'unitcellAA_20180907.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'AA_rotated_graphene\n')
fprintf(fid,'1.0\n')
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base3(1),new_base3(2),new_base3(3));
fprintf(fid,'\tC\n')
fprintf(fid,'\t%i\n',num_of_atom_new);
fprintf(fid,'Cartesian\n')


for i = 1:num_of_atom 
    d(i,:) = [c{1,2}(i),c{1,3}(i),c{1,4}(i)];
    e = cross(-d(i,:)+p1,vect1);
    f = cross(-d(i,:)+p2,vect2);
    g = cross(-d(i,:)+p3,vect3);
    h = cross(-d(i,:)+p4,vect4);
    
     %according to the right hand rule, positive means inside
    if d(i,3) >10 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',d(i,1),d(i,2),d(i,3));
    end
    
end

for i = 1:num_of_atom 
    d(i,:) = [c{1,2}(i),c{1,3}(i),c{1,4}(i)];
    e = cross(-d(i,:)+p5,vect1);
    f = cross(-d(i,:)+p6,vect2);
    g = cross(-d(i,:)+p7,vect3);
    h = cross(-d(i,:)+p8,vect4);
    
    %according to the right hand rule, positive means inside
    if d(i,3) < 10 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',d(i,1),d(i,2),d(i,3));
    end
    
end



fclose(fid)