cimport numpy as np
from cpython.ref cimport PyObject
from CyLP.cy.CyCgl cimport CyCglCutGenerator, CppCglCutGenerator
from CyLP.cy.CyCbcNode cimport CyCbcNode, CppICbcNode


cdef extern from "CbcCompareUser.hpp":
    cdef cppclass CppCbcCompareUser "CbcCompareUser":
        pass
    ctypedef int (*runTest_t)(void* instance, CppICbcNode* x,
                              CppICbcNode* y)
    ctypedef void (*runNewSolution_t)(void*instance, CppICbcModel* model,
                       double objectiveAtContinuous,
                       int numberInfeasibilitiesAtContinuous)
    ctypedef int (*runEvery1000Nodes_t)(void* instance,
                            CppICbcModel* model, int numberNodes)
    bint equalityTest(CppICbcNode* x, CppICbcNode* y)


cdef extern from "ICbcModel.hpp":
    cdef cppclass CppICbcModel "ICbcModel":
        PyObject* getPrimalVariableSolution()

        int getSolutionCount()
        int getNumberHeuristicSolutions()
        int getNodeCount()
        double getObjValue()
        double getBestPossibleObjValue()
        int numberObjects()
        void setNodeCompare(PyObject* obj, runTest_t runTest,
                            runNewSolution_t runNewSolution,
                            runEvery1000Nodes_t runEvery1000Nodes)
        void addCutGenerator(CppCglCutGenerator* generator,
                        int howOften,
                        char* name,
                        bint normal,
                        bint atSolution,
                        bint infeasible,
                        int howOftenInSub,
                        int whatDepth,
                        int whatDepthInSub)
        void branchAndBound(int doStatistics)

cdef class CyCbcModel:
    cdef CppICbcModel* CppSelf
    cdef setCppSelf(self, CppICbcModel* cppmodel)
    cpdef addCutGenerator(self, CyCglCutGenerator generator,
                        howOften=*, name=*, normal=*, atSolution=*,
                        infeasible=*, howOftenInSub=*, whatDepth=*,
                        whatDepthInSub=*)
