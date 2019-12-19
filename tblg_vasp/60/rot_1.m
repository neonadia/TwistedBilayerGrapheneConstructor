close all
clear;clc;

num_of_atom = 100; %need to specify the num of atoms in the origin file
num_of_atom_new = 100;

filename='POSCAR_BLG_10_10.vasp'; %the input of BLG supercell
fid=fopen(filename,'r');

for i = 1:8
    line=fgetl(fid);
end

c = textscan(fid,'%.11f %.11f %.11f',num_of_atom);

%w=1.5; %initial posiztion, need to adjust so that
             %the num of atoms is correct

n = 1; %m and n are determined by twisted angle
m = 0;
cos = (n^2+4*n*m+m^2)/(2*(n^2+n*m+m^2));
sin = sqrt(1-cos^2);

rot_m = [cos -sin; sin cos]; 







filename2 = 'afterrot_AABLG_20180907.xyz';
fid=fopen(filename2,'w');
fprintf(fid,'100\n')


for i = 1:num_of_atom %�������ֶ����жϵ���λ�Ƿ��������жϵ��Ƿ��ڶ�����ڲ�?
    d(i,:) = [c{1,1}(i),c{1,2}(i),c{1,3}(i)];
    if d(i,3) < 10  
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',d(i,1),d(i,2),d(i,3));
    end
    
    if d(i,3) > 10
        e = [c{1,1}(i) ; c{1,2}(i)];
        f =rot_m*e; %˳ʱ����ת
        fprintf(fid,'%s\t%.11f\t %.11f\t %.11f\n','C',f(1),f(2),d(i,3));
    end
end


fclose(fid)