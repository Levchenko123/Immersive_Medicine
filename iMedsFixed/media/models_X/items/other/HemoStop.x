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


Material Material {
 0.800000;0.800000;0.800000;1.000000;;
 324.0000;
 0.500000;0.500000;0.500000;;
 0.250000;0.250000;0.250000;;
 TextureFilename {
 "HemoStop.png";
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
 12;
 0.000228;0.000032;-0.000394;,
 -0.000228;0.000032;-0.000394;,
 -0.000228;0.000032;0.000394;,
 0.000228;0.000032;0.000394;,
 0.000256;0.000000;0.000442;,
 -0.000256;0.000000;0.000442;,
 -0.000256;0.000000;-0.000442;,
 -0.000228;-0.000032;-0.000394;,
 0.000228;-0.000032;-0.000394;,
 0.000228;-0.000032;0.000394;,
 -0.000228;-0.000032;0.000394;,
 0.000256;0.000000;-0.000442;;

 10;
 4;0,1,2,3;,
 4;4,3,2,5;,
 4;5,2,1,6;,
 4;7,8,9,10;,
 4;11,0,3,4;,
 4;6,1,0,11;,
 4;7,6,11,8;,
 4;8,11,4,9;,
 4;10,5,6,7;,
 4;9,4,5,10;;

 MeshMaterialList {
  1;
  10;
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
  {Material}
 }

 MeshNormals {
  12;
  0.250859;0.830185;-0.184900;,
  -0.250859;0.830185;-0.184900;,
  -0.250859;0.830185;0.184900;,
  0.250859;0.830185;0.184900;,
  0.376288;-0.000000;0.277350;,
  -0.376288;-0.000000;0.277350;,
  -0.376288;-0.000000;-0.277350;,
  -0.250859;-0.830185;-0.184900;,
  0.250859;-0.830185;-0.184900;,
  0.250859;-0.830185;0.184900;,
  -0.250859;-0.830185;0.184900;,
  0.376288;-0.000000;-0.277350;;

  10;
  4;0,1,2,3;,
  4;4,3,2,5;,
  4;5,2,1,6;,
  4;7,8,9,10;,
  4;11,0,3,4;,
  4;6,1,0,11;,
  4;7,6,11,8;,
  4;8,11,4,9;,
  4;10,5,6,7;,
  4;9,4,5,10;;
 }

 MeshTextureCoords {
  12;
  0.752953;0.936470;,
  0.247047;0.936470;,
  0.247047;0.063530;,
  0.752953;0.063530;,
  0.784082;0.009816;,
  0.215918;0.009816;,
  0.215918;0.990184;,
  0.247047;0.936470;,
  0.752953;0.936470;,
  0.752953;0.063530;,
  0.247047;0.063530;,
  0.784082;0.990184;;
  }
 }
}
