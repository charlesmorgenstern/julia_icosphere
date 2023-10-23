# julia_icosphere
Icosphere Mesh Generation in Julia
_______________________________________
Functions:

getmesh(n,r) is the main function for generating icosphere meshes. 
n is the number of refinements. n=0 returns an icosahedron.
r is the radius of the sphere.
a=getmesh(n,r) returns a where a[1] is the array of vertices and a[2] is the array of indices for the faces.

icosahedron(r) generates an icosahedron that fits a sphere of radius r.

getmidpoint(p1,p2,r) calculates the midpoint of an edge of a triangle joining point p1 and point p2 and moves the new point onto the sphere of radius r.

icosphere(n,r) generates an icosphere mesh with n refinements for a sphere of radius r. n=0 returns an icosahedron. This function returns a mesh which will have duplicate vertices for n>0, and it is used by getmesh(n,r). getmesh(n,r) should be used for actual mesh generation.

plotmesh(a) plots a mesh generated with either a=getmesh(n,r) or a=icosphere(n,r)

makeverticesunique(a) removes duplicate vertices from a mesh generated with a=icosphere(n,r) and updates the indices of the faces for the new list of vertices. It is used by getmesh(n,r).
