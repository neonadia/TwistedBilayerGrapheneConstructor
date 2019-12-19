close all
clear;clc;

num_of_atom = 14400; %need to specify the num of atoms in the origin file
num_of_atom_new = 1736;

filename='afterrot3_vasp.xyz'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:1
    line=fgetl(fid);
end

c = textscan(fid,'%s %.11f %.11f %.11f',num_of_atom);

w=10; %initial posiztion, need to adjust so that
             %the num of atoms is correct

n = 9; %m and n are determined by twisted angle
m = 8;

%base1 = [sqrt(3)/2, -1/2, 0]*2.46;
%base2 = [sqrt(3)/2, 1/2, 0]*2.46;

base1 = [2.4674074650,0,0];  % need to adjust according to the lattice vector in the origin file
base2 = [1.2337037325,2.1368375462,0];

new_base1=base1 * n + base2 * m; % this equation is from ref
new_base2=-(base1 * (2*m+n)) + base2 * (m + 2*n);
new_base3=[0,0,6.9543900490];

%vect1= [norm(new_base1), 0, 0];
%vect2= [norm(new_base1)/2, sqrt(3)/2*norm(new_base1), 0];
vect1 = new_base1;
vect2 = new_base2;
vect3= -vect1;
vect4= -vect2;

p1=[1,0,3.447195025]; %end points of unit cell on layer 1
p2= p1 + vect1;
p3= p2 + vect2;
p4= p3 + vect3;

p5=[1,0,0]; %end points of unit cell on layer 2
p6= p5 + vect1;
p7= p6 + vect2;
p8= p7 + vect3;





filename2 = 'unitcell3_rec.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'3_rotated_graphene\n')
fprintf(fid,'1.0\n')
fprintf(fid,'\t%f\t %f\t %f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid,'\t%f\t %f\t %f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid,'\t%f\t %f\t %f\n',new_base3(1),new_base3(2),new_base3(3));
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
    if d(i,3) >3 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%f\t %f\t %f\n',d(i,1),d(i,2),d(i,3));
    end
    
end

for i = 1:num_of_atom 
    d(i,:) = [c{1,2}(i),c{1,3}(i),c{1,4}(i)];
    e = cross(-d(i,:)+p5,vect1);
    f = cross(-d(i,:)+p6,vect2);
    g = cross(-d(i,:)+p7,vect3);
    h = cross(-d(i,:)+p8,vect4);
    
    %according to the right hand rule, positive means inside
    if d(i,3) < 2 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%f\t %f\t %f\n',d(i,1),d(i,2),d(i,3));
    end
    
end



fclose(fid)