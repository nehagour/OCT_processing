function f = DsFgf4d(g, nhood, niterations)
%(c) Christos Loizou 2008
%Non-linear filtering: Geometric Filtering
%Source: SPIE Vol. 556 International Conference on Speckle 1985, p. 213-222
%Title: Geometric filter for reducing speckle
%Utilizes the local statistics of the noise image g(m,n )
%Example: out = DsFgf4d (g, [5 5], 5); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isa(g, 'uint8')
  u8out = 1;
  if (islogical(g))
    logicalOut = 1;
    g = double(g);
  else
    logicalOut = 0;  
    g = double(g)/255;    
  end
else
  u8out = 0;
end
inp_image=g; 
%Estimate the size of the image
[ma ,na] = size(g);
%Estimate the midle of the processing window, which takes onle values 3, 5 7,. . 
z=(nhood(1)-1)/2;
%Initialize the picture f (new picture) with zeros
f=g;

for i = 1:niterations
  fprintf('\rIteration %d',i);
  if i >=2 
      g=f;
  end

%Estimate and change the middle pixel in window
disp(['       Calculating/replacing the center pixel in a sliding window...']);
%ma=100; na=100;
a=1; b=0; c=3; d=1; 
while c>=0,
   for d=0:1
      for i= 2 :(ma-1)
         for j= 2:(na-1)
            maxi= min(g(i-a, j-b)-1, g(i, j) +1);
            f(i, j) = max(g(i, j), maxi);
         end	%end for j
      end		%end for i
      
   	for i= 2 :(ma-1)
         for j= 2:(na-1)
            maxin1 = min(f(i-a, j-b), g(i, j) +1);
            maxin = min(maxin1, f(i+a, j+b)+1);
            g(i, j) = max(f(i, j),  maxin);
      	end	%end for j
   	end		%end for i
   	if d==0
      	a=-a; b=-b;
      end 
      
   end	%end if d 
   disp(['First Itteration of the Algorithm is Applied']);
   
   for d=0:1
      for i= 2 :(ma-1)
         for j= 2:(na-1)
            mini = max(g(i-a, j-b)+1, g(i, j) -1);
            f(i, j) = min(g(i, j), mini );
         end	%end for j
      end		%end for i
      
   	for i= 2 :(ma-1)
         for j= 2:(na-1)
            mini1 = max(f(i-a, j-b), g(i, j) -1);
            minin = max (mini1, f(i+a, j+b)-1);
            g(i, j) = min(f(i, j),  minin);
      	end	%end for j
   	end		%end for i
   	if d==0
      	a=-a; b=-b;
      end %end if d
   end	%end for d 
   disp(['Second Itteration of the Algorithm is Applied']);

switch c
case 3
   a=0; b=1; c=2;
   break;
case 2
   a=1; b=1; c=1;
   break;
case 1
   a=1; b=-1; c=0;
   break;
case 0
   c=-1;
   break;
end	%end switch
end % end while c>=0 loop

end
fprintf('\n');

if u8out==1,
  if (logicalOut)
    f = uint8(f);
  else
    f = uint8(round(f*255));
  end
end
close; 
figure, subplot(2,1,1),  imshow(inp_image), title('Original Image');
subplot(2,1,2), imshow(f), title('Despeckled Image by DsFgf4d'); 
