close all
clear;clc;

num_of_atom = 14400; %need to specify the num of atoms in the origin file

filename='AB-BLG-L.vasp'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

n = 9; %m and n are determined by twisted angle
m = 8;
cos = (n^2+4*n*m+m^2)/(2*(n^2+n*m+m^2));
sin = sqrt(1-cos^2);

rot_m = [cos -sin; sin cos]; 







filename2 = 'afterrot3_vasp.xyz';
fid=fopen(filename2,'w');
fprintf(fid,'14400\n')


for i = 1:num_of_atom 
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    if d(i,3) >4
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',d(i,1),d(i,2),3.447195025); %need to change this value according to layer distance
    end
    
    if d(i,3) <4
        e = [c{1,1}(i) ; c{1,2}(i)];
        f =inv(rot_m)*e; %clockwise rotation
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',f(1),f(2),0);
    end
end


fclose(fid)