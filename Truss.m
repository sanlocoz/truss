clc;clear;

%JOINT COORDINATES
NJ=input('Masukkan jumlah joint dari rangka batang: ');
for(i=1:1:NJ)
    fprintf('Joint %d\n',i);
    COOR(i,1)=input('Masukkan koordinat X : ');
    COOR(i,2)=input('Masukkan koordinat Y : ');
end

fprintf('\n');

%SUPPORT DATA
NS=input('Masukkan jumlah tumpuan: ');
for(i=1:1:NS)
    fprintf('Tumpuan %d\n',i);
    MSUP(i,1)=input('Masukkan nomor joint : ');
    MSUP(i,2)=input('Restrain in X dir (0 = free, 1 = restrained) : ');
    MSUP(i,3)=input('Restrain in Y dir (0 = free, 1 = restrained) : ');
end

fprintf('\n');

%MATERIAL DATA
NMP=input('Masukkan jumlah material: ');
for(i=1:1:NMP)
    fprintf('Material %d\n',i);
    EM(i)=input('Masukkan nilai modulus elastisitas (E) : ');
end

fprintf('\n');

%CROSS SECTION DATA
NCP=input('Masukkan jumlah jenis penampang: ');
for(i=1:1:NCP)
    fprintf('Material %d\n',i);
    CP(i)=input('Masukkan luas penampang (A) : ');
end

fprintf('\n');

%MEMBER DATA
NM=input('Masukkan jumlah member: ');
for(i=1:1:NM)
    fprintf('Member %d\n',i);
    MPRP(i,1)=input('Masukkan beginning joint : ');
    MPRP(i,2)=input('Masukkan end joint : ');
    MPRP(i,3)=input('Masukkan nomor material : ');
    MPRP(i,4)=input('Masukkan jenis penampang : ');
end

fprintf('\n');

%JOINT LOAD
NJL=input('Masukkan jumlah joint yang mempunyai load: ');
for(i=1:1:NJL)
    fprintf('Member %d\n',i);
    JL(i,1)=input('Joint Number : ');
    JL(i,2)=input('Force in X direction : ');
    JL(i,3)=input('Force in Y direction : ');
end

%NDOF calc
NR=0;
for(i=1:1:NS)
    if(MSUP(i,2)==1)NR=NR+1; end
    if(MSUP(i,3)==1)NR=NR+1; end
end
NDOF=2*NJ-NR;

%NSC Matrix
icnt=0;jcnt=NDOF;
for(i=1:1:NJ)
    bnr=false;
    for(j=1:1:NS)
        if(MSUP(j,1)==i)
            if(MSUP(j,2)==1) %X dir is restrained
                jcnt=jcnt+1;
                NSC(2*(i-1)+1)=jcnt;
            else
                icnt=icnt+1;
                NSC(2*(i-1)+1)=icnt;
            end
            
            if(MSUP(j,3)==1) %Y dir is restrained
                jcnt=jcnt+1;
                NSC(2*(i-1)+2)=jcnt;
            else
                icnt=icnt+1;
                NSC(2*(i-1)+2)=icnt;
            end
            bnr=true;
        end
    end
    if(~bnr)
        icnt=icnt+1;
        NSC(2*(i-1)+1)=icnt;
        icnt=icnt+1;
        NSC(2*(i-1)+2)=icnt;
    end
end

%Joint Load
JLV=zeros(NDOF,1);
for(i=1:1:NJ)
    if(NSC(2*(i-1)+1)<=NDOF)
    for(j=1:1:NJL)
        if(JL(j,1)==i)
            JLV(NSC(2*(i-1)+1))=JL(j,2);
        end
    end 
    end
    if(NSC(2*(i-1)+2)<=NDOF)
    for(j=1:1:NJL)
        if(JL(j,1)==i)
            JLV(NSC(2*(i-1)+2))=JL(j,3);
        end
    end 
    end
end

%Structure stiffness matrix
S=zeros(NDOF,NDOF);
for(i=1:1:NM)
    JB=MPRP(i,1);
    XB=COOR(JB,1);
    YB=COOR(JB,2);
    JE=MPRP(i,2);
    XE=COOR(JE,1);
    YE=COOR(JE,2);
    E=EM(MPRP(i,3));
    A=CP(MPRP(i,4));
    DX=XE-XB;
    DY=YE-YB;
    L=sqrt(DX^2+DY^2);
    CO=DX/L;
    SI=DY/L;
    GK=zeros(4,4);
    A1=CO^2;
    A2=SI^2;
    A3=CO*SI;
    GK=[A1 A3 -A1 -A3;
        A3 A2 -A3 -A2;
        -A1 -A3 A1 A3;
        -A3 -A2 A3 A2;];
    GK=E*A/(L)*GK;
    for(j=1:1:4)
       for(k=1:1:4)
         kode_b=0;
         kode_k=0;
         if(j<=2)
            kode_b=NSC(2*(JB-1)+j);
         else
            kode_b=NSC(2*(JE-1)+(j-2));
         end
         
         if(k<=2)
            kode_k=NSC(2*(JB-1)+k);
         else
            kode_k=NSC(2*(JE-1)+(k-2));
         end
         if(kode_b<=NDOF&kode_k<=NDOF)
             S(kode_b,kode_k)=S(kode_b,kode_k)+GK(j,k);
         end
        end
    end
end
d=inv(S)*JLV;