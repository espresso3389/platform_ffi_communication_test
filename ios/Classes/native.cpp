#include <stdint.h>

extern "C" uint64_t pfc_allocateData(uint64_t size);
extern "C" void* pfc_ptrFromData(uint64_t data);
extern "C" void pfc_releaseData(uint64_t data);

extern "C" __attribute__((visibility("default"))) __attribute__((used))
void* pfc_test(uint64_t data)
{
    return pfc_ptrFromData(data);
}
