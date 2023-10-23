using LinearAlgebra: norm
using Plots
##################################################
##################################################
function getmesh(n,r)
#main function to generate an icosphere mesh
#n is number of refinements. n=0 returns icosahedron.
#r is radius of the sphere.

a=icosphere(n,r) #generate mesh
a=makeverticesunique(a) #remove duplicate vertices and reindex faces

return a #a[1] is array of vertices. a[2] is array of indices for faces.
end
##################################################
##################################################
function icosahedron(r)
#generate an icosahdron fitting a sphere of radius r.

t = (1+sqrt(5)) / 2 

#list of vertices
v = [[-1 t 0]; 
      [1  t  0]; 
     [-1 -t  0]; 
      [1 -t  0]; 
      [0 -1  t]; 
      [0  1  t]; 
      [0 -1 -t]; 
      [0  1 -t]; 
      [t  0 -1]; 
      [t  0  1]; 
     [-t  0 -1]; 
     [-t  0  1]] 

#resize vertices to fit sphere of radius r.
v = v./((1/r)*norm(v[1,:]));

#indices of vertices for each face
f = [ [1 12  6]; 
      [1  6  2]; 
      [1  2  8]; 
      [1  8 11]; 
      [1 11 12]; 
      [2  6 10]; 
      [6 12  5]; 
     [12 11  3]; 
     [11  8  7]; 
      [8  2  9]; 
      [4 10  5]; 
      [4  5  3]; 
      [4  3  7]; 
      [4  7  9]; 
      [4  9 10]; 
      [5 10  6]; 
      [3  5 12]; 
      [7  3 11]; 
      [9  7  8]; 
     [10  9  2]] 

return v, f

end
##################################################
##################################################
function getmidpoint(p1,p2,r)
#calculate mid point of edge of triangle and move onto the sphere.

pm=(p1+p2)./2
pm=pm./((1/r)*norm(pm))

return pm
end
##################################################
##################################################
function icosphere(n,r)
#generate an icosphere mesh.
#mesh will have duplicate vertices if n>0
#n is number of refinements. n=0 returns icosahedron.
#r is radius of the sphere.

#get an icosahedron
a=icosahedron(r)
v=a[1]
f=a[2]

#refine the icosahedron n times
for nref=1:n
nf=length(f[:,1])
fnew=Matrix{Int64}(undef,nf*4,3)

#refine each triangle
for i=1:nf
tri=f[i,:]
p1=v[tri[1],:]
p2=v[tri[2],:]
p3=v[tri[3],:]

#add mid point to each edge
v1=getmidpoint(p1,p2,r)
v2=getmidpoint(p2,p3,r)
v3=getmidpoint(p3,p1,r)

j=length(v[:,1])

v=[v;v1']
v=[v;v2']
v=[v;v3']

a=j+1
b=j+2
c=j+3

#add connectivity of new triangles
fnew[4*(i-1)+1:4*i,:]=[tri[1] a c; tri[2] b a;tri[3] c b; a b c]
end
f=fnew
end

return v, f
end
##################################################
##################################################
function plotmesh(a)
#plot a mesh from icosphere(n,r) or getmesh(n,r)

p=a[1]
f=a[2]
n=length(a[2][:,1])
fig=plot()
for i=1:n
x=p[f[i,:],1]
y=p[f[i,:],2]
z=p[f[i,:],3]
plot!([x; x[1]],[y; y[1]],[z; z[1]],legend=false)
end
return fig
end
##################################################
##################################################
function makeverticesunique(a)
#remove duplicate vertices from a mesh and redefine the connectivity for faces

v=a[1]
f=a[2]

n=length(v[:,1])
i=1

while n>0

 p1=v[i,:]
 np=length(v[:,1])
 j=i+1 

   while j<=np 

    p2=v[j,:]
    check=norm(p1.-p2)

     if check<10^-10

      v=v[1:end .!=j,:]
      nf=length(f[:,1])

       for k=1:nf
        for m=1:3

         if f[k,m]==j
          f[k,m]=i
         elseif f[k,m]>j
          f[k,m]=f[k,m]-1
         end

        end
       end     

      np=length(v[:,1])

      n=n-1 
    end

   j=j+1

  end

 n=n-1
 i=i+1

end

return v, f
end
