xof 0302txt 0064
template Header {
 <3D82AB43-62DA-11cf-AB39-0020AF71E433>
 WORD major;
 WORD minor;
 DWORD flags;
}

template Vector {
 <3D82AB5E-62DA-11cf-AB39-0020AF71E433>
 FLOAT x;
 FLOAT y;
 FLOAT z;
}

template Coords2d {
 <F6F23F44-7686-11cf-8F52-0040333594A3>
 FLOAT u;
 FLOAT v;
}

template Matrix4x4 {
 <F6F23F45-7686-11cf-8F52-0040333594A3>
 array FLOAT matrix[16];
}

template ColorRGBA {
 <35FF44E0-6C7C-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
 FLOAT alpha;
}

template ColorRGB {
 <D3E16E81-7835-11cf-8F52-0040333594A3>
 FLOAT red;
 FLOAT green;
 FLOAT blue;
}

template Material {
 <3D82AB4D-62DA-11cf-AB39-0020AF71E433>
 ColorRGBA faceColor;
 FLOAT power;
 ColorRGB specularColor;
 ColorRGB emissiveColor;
 [...]
}

template MeshFace {
 <3D82AB5F-62DA-11cf-AB39-0020AF71E433>
 DWORD nFaceVertexIndices;
 array DWORD faceVertexIndices[nFaceVertexIndices];
}

template MeshTextureCoords {
 <F6F23F40-7686-11cf-8F52-0040333594A3>
 DWORD nTextureCoords;
 array Coords2d textureCoords[nTextureCoords];
}

template MeshMaterialList {
 <F6F23F42-7686-11cf-8F52-0040333594A3>
 DWORD nMaterials;
 DWORD nFaceIndexes;
 array DWORD faceIndexes[nFaceIndexes];
 [Material]
}

template MeshNormals {
 <F6F23F43-7686-11cf-8F52-0040333594A3>
 DWORD nNormals;
 array Vector normals[nNormals];
 DWORD nFaceNormals;
 array MeshFace faceNormals[nFaceNormals];
}

template Mesh {
 <3D82AB44-62DA-11cf-AB39-0020AF71E433>
 DWORD nVertices;
 array Vector vertices[nVertices];
 DWORD nFaces;
 array MeshFace faces[nFaces];
 [...]
}

template FrameTransformMatrix {
 <F6F23F41-7686-11cf-8F52-0040333594A3>
 Matrix4x4 frameMatrix;
}

template Frame {
 <3D82AB46-62DA-11cf-AB39-0020AF71E433>
 [...]
}


Material Material.002 {
 0.800000;0.800000;0.800000;1.000000;;
 225.0000;
 0.500000;0.500000;0.500000;;
 0.250000;0.250000;0.250000;;
 TextureFilename {
 "Needle.png";
 }
}

Header {
 1;
 0;
 1;
}

Frame Model1 {
 FrameTransformMatrix {
  1.000000,0.000000,0.000000,0.000000,
  0.000000,1.000000,0.000000,0.000000,
  0.000000,0.000000,1.000000,0.000000,
  0.000000,0.000000,0.000000,1.000000;;
 }
Mesh Model1 {
 16;
 -0.000261;0.000000;0.000014;,
 -0.000261;0.000014;0.000000;,
 -0.000261;0.000000;-0.000014;,
 -0.000261;-0.000014;0.000000;,
 0.000165;-0.000047;0.000000;,
 0.000165;0.000000;-0.000047;,
 0.000261;0.000000;-0.000047;,
 0.000261;-0.000047;0.000000;,
 0.000261;0.000047;0.000000;,
 0.000261;0.000000;0.000047;,
 0.000138;0.000000;0.000014;,
 0.000138;0.000014;0.000000;,
 0.000165;0.000000;0.000047;,
 0.000138;0.000000;-0.000014;,
 0.000165;0.000047;0.000000;,
 0.000138;-0.000014;0.000000;;

 14;
 4;0,1,2,3;,
 4;4,5,6,7;,
 4;7,6,8,9;,
 4;10,11,1,0;,
 4;4,7,9,12;,
 4;13,2,1,11;,
 4;6,5,14,8;,
 4;15,4,12,10;,
 4;9,8,14,12;,
 4;15,13,5,4;,
 4;3,2,13,15;,
 4;3,15,10,0;,
 4;5,13,11,14;,
 4;12,14,11,10;;

 MeshMaterialList {
  1;
  14;
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0;;
  {Material.002}
 }

 MeshNormals {
  16;
  -0.333333;0.000000;0.471405;,
  -0.333333;0.471405;0.000000;,
  -0.333333;0.000000;-0.471405;,
  -0.333333;-0.471405;0.000000;,
  -0.326941;-0.621051;0.000000;,
  -0.326941;0.000000;-0.621051;,
  0.333333;0.000000;-0.471405;,
  0.333333;-0.471405;0.000000;,
  0.333333;0.471405;0.000000;,
  0.333333;0.000000;0.471405;,
  -0.326941;-0.000000;0.621051;,
  -0.326941;0.621051;0.000000;,
  -0.326941;-0.000000;0.621051;,
  -0.326941;0.000000;-0.621051;,
  -0.326941;0.621051;0.000000;,
  -0.326941;-0.621051;0.000000;;

  14;
  4;0,1,2,3;,
  4;4,5,6,7;,
  4;7,6,8,9;,
  4;10,11,1,0;,
  4;4,7,9,12;,
  4;13,2,1,11;,
  4;6,5,14,8;,
  4;15,4,12,10;,
  4;9,8,14,12;,
  4;15,13,5,4;,
  4;3,2,13,15;,
  4;3,15,10,0;,
  4;5,13,11,14;,
  4;12,14,11,10;;
 }

 MeshTextureCoords {
  16;
  0.020896;0.474229;,
  0.020896;0.500000;,
  0.020896;0.525771;,
  0.020896;0.500000;,
  0.802226;0.500000;,
  0.802226;0.585903;,
  0.979104;0.585903;,
  0.979104;0.500000;,
  0.979104;0.500000;,
  0.979104;0.414097;,
  0.753493;0.474229;,
  0.753493;0.500000;,
  0.802226;0.414097;,
  0.753493;0.525771;,
  0.802226;0.500000;,
  0.753493;0.500000;;
  }
 }
}
