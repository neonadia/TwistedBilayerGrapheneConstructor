close all
clear;clc;


n = 5;
m = 4;
w=10; %initial posiztion, need to adjust so that
             %the num of atoms is correct
num_of_atom = 5200; %need to specify the num of atoms in the origin file
num_of_atom_new = (n^2+m^2+m*n)*4;

filename_r1='CONTCAR_32_unrotated_10_10_car.vasp'; %the input of bilayer graphene supercell after rotation
fid_r1=fopen(filename_r1,'r');

for i = 1:8
    line=fgetl(fid_r1);
end

c = textscan(fid_r1,'%.11f %.11f %.11f',num_of_atom);

new_base1=[18.79400790672,-4.14300385090,0.00000000000]; 
new_base2=[-5.80905926198,18.34758848257,0.00000000000];
new_base3=[0,0,6.4266276360];

%vect1= [norm(new_base1), 0, 0];
%vect2= [norm(new_base1)/2, sqrt(3)/2*norm(new_base1), 0];
vect1 = new_base1;
vect2 = new_base2;
vect3= -vect1;
vect4= -vect2;

p1=[w,w,c{1,3}(5200)]; %end points of unit cell on layer 1
p2= p1 + vect1;
p3= p2 + vect2;
p4= p3 + vect3;

p5=[w,w,c{1,3}(1)]; %end points of unit cell on layer 2
p6= p5 + vect1;
p7= p6 + vect2;
p8= p7 + vect3;





filename2 = 'unitcellun7D34_20190123.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'7D34_unrotated_graphene\n')
fprintf(fid,'1.0\n')
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base1(1),new_base1(2),new_base1(3));
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base2(1),new_base2(2),new_base2(3));
fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',new_base3(1),new_base3(2),new_base3(3));
fprintf(fid,'\tC\n')
fprintf(fid,'\t%i\n',num_of_atom_new);
fprintf(fid,'Cartesian\n')


for i = 1:num_of_atom 
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    e = cross(-d(i,:)+p1,vect1);
    f = cross(-d(i,:)+p2,vect2);
    g = cross(-d(i,:)+p3,vect3);
    h = cross(-d(i,:)+p4,vect4);
    
     %according to the right hand rule, positive means inside
    if d(i,3) >3 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',d(i,1),d(i,2),d(i,3));
    end
    
end

for i = 1:num_of_atom 
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    e = cross(-d(i,:)+p5,vect1);
    f = cross(-d(i,:)+p6,vect2);
    g = cross(-d(i,:)+p7,vect3);
    h = cross(-d(i,:)+p8,vect4);
    
    %according to the right hand rule, positive means inside
    if d(i,3) < 3 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',d(i,1),d(i,2),d(i,3));
    end
    
end



fclose(fid)