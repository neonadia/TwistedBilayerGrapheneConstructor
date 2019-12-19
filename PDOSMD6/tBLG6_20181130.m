close all
clear;clc;

num_of_atom = 11200; %need to specify the num of atoms in the origin file
num_of_atom_new = 364;

filename_r1='afterrot_6.xyz'; %the input of bilayer graphene supercell after rotation
fid_r1=fopen(filename_r1,'r');

for i = 1:1
    line=fgetl(fid_r1);
end

c = textscan(fid_r1,'%s %.11f %.11f %.11f',num_of_atom);



w=30; %initial posiztion, need to adjust so that
             %the num of atoms is correct
             
 base1_21 = [-6.5194172859,0.0000000000,0];  %21 degree base
 base2_21 = [-3.2597086430,5.6459809875,0];
 
 base1 = (base1_21 +2*base2_21)/7;    %0 degree  base
 base2 = (3*base1_21 - base2_21)/7;

new_base1=6*base1 + 5*base2; % new base for 6 degree
new_base2=-5*base1 + 11*base2;
new_base3=[0,0,6.4266276360];

%vect1= [norm(new_base1), 0, 0];
%vect2= [norm(new_base1)/2, sqrt(3)/2*norm(new_base1), 0];
vect1 = new_base1;
vect2 = new_base2;
vect3= -vect1;
vect4= -vect2;

p1=[w,w,c{1,4}(2800)]; %end points of unit cell on layer 1
p2= p1 + vect1;
p3= p2 + vect2;
p4= p3 + vect3;

p5=[w,w,c{1,4}(1)]; %end points of unit cell on layer 2
p6= p5 + vect1;
p7= p6 + vect2;
p8= p7 + vect3;





filename2 = 'unitcell6_20181130.vasp';
fid=fopen(filename2,'w');
fprintf(fid,'6_rotated_graphene\n')
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
    if d(i,3) >3 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
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
    if d(i,3) < 3 && e(1,3) > 0 && f(1,3) > 0 && g(1,3) > 0 && h(1,3) > 0 
    fprintf(fid,'\t%.11f\t %.11f\t %.11f\n',d(i,1),d(i,2),d(i,3));
    end
    
end



fclose(fid)