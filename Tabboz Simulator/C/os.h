#ifndef TABBOZ_OS_H
#define TABBOZ_OS_H

#include <stdio.h>
#include <Foundation/Foundation.h>

#ifdef CLI
#include "Tabboz_Simulator-Swift.h"
#else
#include "Tabboz_macOS-Swift.h"
#endif

#include "stubs.h"

#endif
