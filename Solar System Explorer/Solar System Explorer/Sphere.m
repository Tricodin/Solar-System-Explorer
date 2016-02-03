//
//  Sphere.m
//  InnerPlanets
//
//  Created by Jarret Francis Kolanko on 2015-03-10.
//  Copyright (c) 2015 Jarret Francis Kolanko. All rights reserved.
//
#import "Sphere.h"

@interface Sphere (){
    int _numSegment, _numIndex, _numVertex;
    
    GLfloat* _vertices;
    GLushort* _indices;
    
    GLuint _vertexBuff, _indexBuff, _tangentBuff;
    
    CGPoint _center;
}
@end


@implementation Sphere

-(Sphere*) init: (int) seg{
    self = [super init];
    
    if (self){
        _vertexBuff = _indexBuff = _tangentBuff = 0;
        _numSegment = seg;
        _numVertex = (seg*2+1)*(seg+1);
        _numIndex = (seg*2+1)*seg*2;
        
        _vertices = (GLfloat *)malloc(_numVertex*5*sizeof(GLfloat));
        _indices = (GLushort*)malloc(_numIndex*sizeof(GLushort));
        
        for ( int i=0, c=0; i<=seg; i++){
            float y = cos(M_PI*i/seg);
            float xz = sin(M_PI*i/seg);
            float v = (float)i/seg;
            
            for( int j=0; j<=seg*2; j++, c+=5){
                _vertices[c] = cos(M_PI*j/seg) * xz;
                _vertices[c+1] = y;
                _vertices[c+2] =  -sin(M_PI*j/seg) * xz;
                _vertices[c+3] = (float)j/seg/2;
                _vertices[c+4] = v;
                
            }
            
            for( int i=0, k=0, c=0; i<seg; i++){
                for( int j=0; j<=seg*2; j++,k++,c+=2){
                    _indices[c] = k;
                    _indices[c+1] = k+seg*2+1;
                }
            }
        }
    }
    
    return self;
}

- (void)dealloc {
    glDeleteBuffers(1, &_vertexBuff);
    glDeleteVertexArraysOES(1, &_indexBuff);
    free(_vertices);
    free(_indices);
}

-(void)createVertexBufferObject{
    glGenBuffers(1, &_vertexBuff);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuff);
    glBufferData(GL_ARRAY_BUFFER, _numVertex*5*sizeof(GLfloat), _vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuff);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuff);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _numIndex*sizeof(GLushort), _indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(ATTRIBUTE_POSITION);
    glVertexAttribPointer(ATTRIBUTE_POSITION, 3, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), 0);
    glEnableVertexAttribArray(ATTRIBUTE_NORMAL);
    glVertexAttribPointer(ATTRIBUTE_NORMAL, 3, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), 0);
    glEnableVertexAttribArray(ATTRIBUTE_TEXCOORDINATE);
    glVertexAttribPointer(ATTRIBUTE_TEXCOORDINATE, 2, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), ((float*)0)+3);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

-(void) createTangentVBO{
    GLfloat* tangents = (GLfloat*)malloc(_numVertex*6*sizeof(GLfloat));
    
    for(int i =0, c=0; i<= _numSegment; i++){
        float y = cos(M_PI*i/_numSegment);
        float xz = sin(M_PI*i/_numSegment);
        for( int j=0; j<=_numSegment*2; j++, c+=6){
            tangents[c] = -sin(M_PI*j/_numSegment);
            tangents[c+1] = 0;
            tangents[c+2] = cos(M_PI*j/_numSegment);
            tangents[c+3] = cos(M_PI*j/_numSegment)*y;
            tangents[c+4] = -xz;
            tangents[c+5] = sin(M_PI*j/_numSegment)*y;
        }
    }
    
    glGenBuffers(1, &_tangentBuff);
    glBindBuffer(GL_ARRAY_BUFFER,_tangentBuff);
    glBufferData(GL_ARRAY_BUFFER, _numVertex*6*sizeof(GLfloat), tangents, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(ATTRIBUTE_TANGENT);
    glVertexAttribPointer(ATTRIBUTE_TANGENT, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), 0);
    glEnableVertexAttribArray(ATTRIBUTE_BITANGENT);
    glVertexAttribPointer(ATTRIBUTE_BITANGENT, 2, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), ((float*)0)+3);
    
    free(tangents);
    
    glBindBuffer(GL_ARRAY_BUFFER,0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

-(void)drawOpenGLES1{
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, sizeof(GLfloat)*5, _vertices);
    glNormalPointer(GL_FLOAT, sizeof(GLfloat)*5, _vertices);
    glTexCoordPointer(2, GL_FLOAT, sizeof(GLfloat)*5, _vertices+3);
    
    for( int i=0, c=0; i<_numSegment; i++, c+=(_numSegment*2+1)*2){
        glDrawElements(GL_TRIANGLE_STRIP, (_numSegment*2+1)*2, GL_UNSIGNED_SHORT, _indices+c);
    }
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void)drawOpenGLES2{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuff);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuff);
    
    for( int j=0, c=0; j<_numSegment; j++, c+=(_numSegment*2+1)*2){
        glDrawElements(GL_TRIANGLE_STRIP, (_numSegment*2+1)*2, GL_UNSIGNED_SHORT, _indices+c);
    }
    
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
}

-(void) setCenter:(CGPoint) pnt{
    _center = pnt;
}

-(CGPoint) Center{
    return _center;
}
@end