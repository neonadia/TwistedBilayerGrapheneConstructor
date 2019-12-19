close all
clear;clc;

num_of_atom = 3600; %need to specify the num of atoms in the origin file

filename='AB-BLG.vasp'; %the input should be comming from shanshan's code
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%f %f %f',num_of_atom);

n = 3; %m and n are determined by twisted angle
m = 1;
cos = (n^2+4*n*m+m^2)/(2*(n^2+n*m+m^2));
sin = sqrt(1-cos^2);

rot_m = [cos -sin; sin cos]; 







filename2 = 'afterrot32_vasp.xyz';
fid=fopen(filename2,'w');
fprintf(fid,'3600\n')


for i = 1:num_of_atom 
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    if d(i,3) >4
        fprintf(fid,'%s\t%f\t %f\t %f\n','C',d(i,1),d(i,2),3.447195025); %need to change this value according to layer distance
    end
    
    if d(i,3) <4
        e = [c{1,1}(i) ; c{1,2}(i)];
        %f =inv(rot_m)*e; %clockwise rotation
        f =rot_m*e;
        fprintf(fid,'%s\t%f\t %f\t %f\n','C',f(1),f(2),0);
    end
end


fclose(fid)