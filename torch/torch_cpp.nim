import fragments/ffi/cpp as cpp
export cpp
import os

defineCppType(ATensor, "at::Tensor", "ATen/ATen.h")
defineCppType(AScalar, "at::Scalar", "ATen/ATen.h")
defineCppType(AScalarType, "at::ScalarType", "ATen/ATen.h")
defineCppType(IntList, "at::IntList", "ATen/ATen.h")
defineCppType(AGenerator, "at::Generator", "ATen/ATen.h")
defineCppType(AContext, "at::Context", "ATen/ATen.h")
defineCppType(ATensors, "std::vector<at::Tensor>", "vector")

when defined cuda:
  defineCppType(ACUDAStream, "at::cuda::CUDAStream", "ATen/cuda/CUDAContext.h")

var ATkByte {.importcpp: "at::kByte", nodecl.}: AScalarType
var ATkChar {.importcpp: "at::kChar", nodecl.}: AScalarType
var ATkShort {.importcpp: "at::kShort", nodecl.}: AScalarType
var ATkInt {.importcpp: "at::kInt", nodecl.}: AScalarType
var ATkLong {.importcpp: "at::kLong", nodecl.}: AScalarType
var ATkHalf {.importcpp: "at::kHalf", nodecl.}: AScalarType
var ATkFloat {.importcpp: "at::kFloat", nodecl.}: AScalarType
var ATkDouble {.importcpp: "at::kDouble", nodecl.}: AScalarType

proc toATenType(nimType: typedesc[byte]): AScalarType {.inline.} = ATkByte
proc toATenType(nimType: typedesc[char]): AScalarType {.inline.} = ATkChar
proc toATenType(nimType: typedesc[int16]): AScalarType {.inline.} = ATkShort
proc toATenType(nimType: typedesc[int32]): AScalarType {.inline.} = ATkInt
proc toATenType(nimType: typedesc[int64]): AScalarType {.inline.} = ATkLong
proc toATenType(nimType: typedesc[float32]): AScalarType {.inline.} = ATkFloat
proc toATenType(nimType: typedesc[float64]): AScalarType {.inline.} = ATkDouble

proc ACPU(): CppProxy {.importcpp: "at::CPU(at::kFloat)".}
proc ACUDA(): CppProxy {.importcpp: "at::CUDA(at::kFloat)".}
proc ACPU(dtype: AScalarType): CppProxy {.importcpp: "at::CPU(#)".}
proc ACUDA(dtype: AScalarType): CppProxy {.importcpp: "at::CUDA(#)".}
proc printTensor(t: ATensor) {.importcpp: "at::print(#)".}
proc globalContext(): AContext {.importcpp: "at::globalContext()".}
var BackendCPU* {.importcpp: "at::Backend::CPU", nodecl.}: cint
var BackendCUDA* {.importcpp: "at::Backend::CUDA", nodecl.}: cint

{.passC: "-I$ATEN/include".}

static:
  doAssert(getenv("ATEN") != "", "Please add $ATEN variable installation path to the environment")

when defined wasm:
  {.passL: "-L$ATEN/lib -lATen_cpu".}
  
  type ilsize* = clonglong
  
elif defined cuda:
  {.passL: "-Wl,--no-as-needed -L$ATEN/lib -L$ATEN/lib64 -lATen_cpu -lATen_cuda -lsleef -lcpuinfo -lcuda -pthread -fopenmp -lrt".}

  type ilsize* = clong

else:
  {.passL: "-L$ATEN/lib -L$ATEN/lib64 -lATen_cpu -lsleef -lcpuinfo -pthread -fopenmp -lrt".}

  type ilsize* = clong