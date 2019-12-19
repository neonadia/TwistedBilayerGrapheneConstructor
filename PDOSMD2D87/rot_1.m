close all
clear;clc;

num_of_atom = 83200; %need to specify the num of atoms in the origin file
num_of_atom_new = 1588;

filename='CONTCAR_32_unrotated_40_40_car.vasp'; %the input of BLG supercell
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

%w=1.5; %initial posiztion, need to adjust so that
             %the num of atoms is correct

n = 12; %m and n are determined by twisted angle
m = 11;
cos = (n^2+4*n*m+m^2)/(2*(n^2+n*m+m^2));
sin = sqrt(1-cos^2);

rot_m = [cos -sin; sin cos]; 







filename2 = 'afterrot_2D87.xyz';
fid=fopen(filename2,'w');
fprintf(fid,'83200\n')


for i = 1:num_of_atom %�������ֶ����жϵ���λ�Ƿ��������жϵ��Ƿ��ڶ�����ڲ�?
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    if d(i,3) > 3
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',d(i,1),d(i,2),d(i,3));
    end
    
    if d(i,3) < 3
        e = [c{1,1}(i) ; c{1,2}(i)];
        f =rot_m*e; %˳ʱ����ת
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',f(1),f(2),d(i,3));
    end
end


fclose(fid)