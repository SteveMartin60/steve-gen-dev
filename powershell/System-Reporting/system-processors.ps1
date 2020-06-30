CLS

$ComputerName = $Env:COMPUTERNAME

#..............................................................................

#..............................................................................
Function Get-ProcessorType($ProcessorType)
{
    $Result = "Undefined Value"
    
    if ($ProcessorType -eq 1) {$Result = 'Other'            }
    if ($ProcessorType -eq 2) {$Result = 'Unknown'          }
    if ($ProcessorType -eq 3) {$Result = 'Central Processor'}
    if ($ProcessorType -eq 4) {$Result = 'Math Processor'   }
    if ($ProcessorType -eq 5) {$Result = 'DSP Processor'    }
    if ($ProcessorType -eq 6) {$Result = 'Video Processor'  }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-UpgradeMethod($UpgradeMethod)
{
    $Result = "Undefined Value"

    if ($UpgradeMethod -eq 01) {$Result = 'Other'                 }
    if ($UpgradeMethod -eq 02) {$Result = 'Unknown'               }
    if ($UpgradeMethod -eq 03) {$Result = 'Daughter Board'        }
    if ($UpgradeMethod -eq 04) {$Result = 'ZIF Socket'            }
    if ($UpgradeMethod -eq 05) {$Result = 'Replacement/Piggy Back'}
    if ($UpgradeMethod -eq 06) {$Result = 'None'                  }
    if ($UpgradeMethod -eq 07) {$Result = 'LIF Socket'            }
    if ($UpgradeMethod -eq 08) {$Result = 'Slot 1'                }
    if ($UpgradeMethod -eq 09) {$Result = 'Slot 2'                }
    if ($UpgradeMethod -eq 10) {$Result = '370 Pin Socket'        }
    if ($UpgradeMethod -eq 11) {$Result = 'Slot A'                }
    if ($UpgradeMethod -eq 12) {$Result = 'Slot M'                }
    if ($UpgradeMethod -eq 13) {$Result = 'Socket 423'            }
    if ($UpgradeMethod -eq 14) {$Result = 'Socket A (Socket 462)' }
    if ($UpgradeMethod -eq 15) {$Result = 'Socket 478'            }
    if ($UpgradeMethod -eq 16) {$Result = 'Socket 754'            }
    if ($UpgradeMethod -eq 17) {$Result = 'Socket 940'            }
    if ($UpgradeMethod -eq 18) {$Result = 'Socket 939'            }
    if ($UpgradeMethod -eq 19) {$Result = 'Socket mPGA604'        }
    if ($UpgradeMethod -eq 20) {$Result = 'Socket LGA771'         }
    if ($UpgradeMethod -eq 21) {$Result = 'Socket LGA775'         }
    if ($UpgradeMethod -eq 22) {$Result = 'Socket S1'             }
    if ($UpgradeMethod -eq 23) {$Result = 'Socket AM2'            }
    if ($UpgradeMethod -eq 24) {$Result = 'Socket F (1207)'       }
    if ($UpgradeMethod -eq 25) {$Result = 'Socket LGA1366'        }
    if ($UpgradeMethod -eq 26) {$Result = 'Socket G34'            }
    if ($UpgradeMethod -eq 27) {$Result = 'Socket AM3'            }
    if ($UpgradeMethod -eq 28) {$Result = 'Socket C32'            }
    if ($UpgradeMethod -eq 29) {$Result = 'Socket LGA1156'        }
    if ($UpgradeMethod -eq 30) {$Result = 'Socket LGA1567'        }
    if ($UpgradeMethod -eq 31) {$Result = 'Socket PGA988A'        }
    if ($UpgradeMethod -eq 32) {$Result = 'Socket BGA1288'        }
    if ($UpgradeMethod -eq 33) {$Result = 'Socket rPGA988B'       }
    if ($UpgradeMethod -eq 34) {$Result = 'Socket BGA1023'        }
    if ($UpgradeMethod -eq 35) {$Result = 'Socket BGA1224'        }
    if ($UpgradeMethod -eq 36) {$Result = 'Socket LGA1155'        }
    if ($UpgradeMethod -eq 37) {$Result = 'Socket LGA1356'        }
    if ($UpgradeMethod -eq 38) {$Result = 'Socket LGA2011'        }
    if ($UpgradeMethod -eq 39) {$Result = 'Socket FS1'            }
    if ($UpgradeMethod -eq 40) {$Result = 'Socket FS2'            }
    if ($UpgradeMethod -eq 41) {$Result = 'Socket FM1'            }
    if ($UpgradeMethod -eq 42) {$Result = 'Socket FM2'            }
    if ($UpgradeMethod -eq 43) {$Result = 'Socket LGA2011-3'      }
    if ($UpgradeMethod -eq 44) {$Result = 'Socket LGA1356-3'      }
    if ($UpgradeMethod -eq 45) {$Result = 'Socket LGA1150'        }
    if ($UpgradeMethod -eq 46) {$Result = 'Socket BGA1168'        }
    if ($UpgradeMethod -eq 47) {$Result = 'Socket BGA1234'        }
    if ($UpgradeMethod -eq 48) {$Result = 'Socket BGA1364'        }
    if ($UpgradeMethod -eq 49) {$Result = 'Socket AM4'            }
    if ($UpgradeMethod -eq 50) {$Result = 'Socket LGA1151'        }
    if ($UpgradeMethod -eq 51) {$Result = 'Socket BGA1356'        }
    if ($UpgradeMethod -eq 52) {$Result = 'Socket BGA1440'        }
    if ($UpgradeMethod -eq 53) {$Result = 'Socket BGA1515'        }
    if ($UpgradeMethod -eq 54) {$Result = 'Socket LGA3647-1'      }
    if ($UpgradeMethod -eq 55) {$Result = 'Socket SP3'            }
    if ($UpgradeMethod -eq 56) {$Result = 'Socket SP3r2'          }

    Return $Result
}
#..............................................................................

#..............................................................................

Function Get-CPUFamily($Fam)
{
    $F = 'Undefined Value'
    
    if($Fam -eq 001) {$F = 'Other'                         } if($Fam -eq 002) {$F = 'Unknown'                             } if($Fam -eq 003) {$F = '8086'                             } if($Fam -eq 004) {$F = '80286'                         }
    if($Fam -eq 005) {$F = '80386'                         } if($Fam -eq 006) {$F = '80486'                               } if($Fam -eq 007) {$F = '8087'                             } if($Fam -eq 008) {$F = '80287'                         }
    if($Fam -eq 009) {$F = '80387'                         } if($Fam -eq 010) {$F = '80487'                               } if($Fam -eq 011) {$F = 'Pentium brand'                    } if($Fam -eq 012) {$F = 'Pentium Pro'                   }
    if($Fam -eq 013) {$F = 'Pentium II'                    } if($Fam -eq 014) {$F = 'Pentium with MMX'                    } if($Fam -eq 015) {$F = 'Celeron'                          } if($Fam -eq 016) {$F = 'Pentium II Xeon'               }
    if($Fam -eq 017) {$F = 'Pentium III'                   } if($Fam -eq 018) {$F = 'M1 Family'                           } if($Fam -eq 019) {$F = 'M2 Family'                        } if($Fam -eq 020) {$F = 'Intel Celeron M'               } 
    if($Fam -eq 021) {$F = 'Intel Pentium 4 HT'            } if($Fam -eq 024) {$F = 'K5 Family'                           } if($Fam -eq 025) {$F = 'K6 Family'                        } if($Fam -eq 026) {$F = 'K6-2'                          }
    if($Fam -eq 027) {$F = 'K6-3'                          } if($Fam -eq 028) {$F = 'AMD Athlon'                          } if($Fam -eq 029) {$F = 'AMD Duron'                        } if($Fam -eq 030) {$F = 'AMD29000 Family'               }
    if($Fam -eq 031) {$F = 'K6-2+'                         } if($Fam -eq 032) {$F = 'Power PC Family'                     } if($Fam -eq 033) {$F = 'Power PC 601'                     } if($Fam -eq 034) {$F = 'Power PC 603'                  } 
    if($Fam -eq 035) {$F = 'Power PC 603+'                 } if($Fam -eq 036) {$F = 'Power PC 604'                        } if($Fam -eq 037) {$F = 'Power PC 620'                     } if($Fam -eq 038) {$F = 'Power PC X704'                 }
    if($Fam -eq 039) {$F = 'Power PC 750'                  } if($Fam -eq 040) {$F = 'Intel Core Duo'                      } if($Fam -eq 041) {$F = 'Intel Core Duo mobile'            } if($Fam -eq 042) {$F = 'Intel Core Solo Mobile'        }
    if($Fam -eq 043) {$F = 'Intel Atom processor'          } if($Fam -eq 048) {$F = 'Alpha Family'                        } if($Fam -eq 049) {$F = 'Alpha 21064'                      } if($Fam -eq 050) {$F = 'Alpha 21066'                   } 
    if($Fam -eq 051) {$F = 'Alpha 21164'                   } if($Fam -eq 052) {$F = 'Alpha 21164PC'                       } if($Fam -eq 053) {$F = 'Alpha 21164a'                     } if($Fam -eq 054) {$F = 'Alpha 21264'                   }
    if($Fam -eq 055) {$F = 'Alpha 21364'                   } if($Fam -eq 056) {$F = 'AMD Turion II Ultra Dual-Core Mobile'} if($Fam -eq 057) {$F = 'AMD Turion II Dual-Core Mobile'   } if($Fam -eq 058) {$F = 'AMD Athlon II Dual-Core Mobile'}
    if($Fam -eq 059) {$F = 'AMD Opteron 6100 Series'       } if($Fam -eq 060) {$F = 'AMD Opteron 4100 Series Processor'   } if($Fam -eq 061) {$F = 'AMD Opteron 6200 Series'          } if($Fam -eq 062) {$F = 'AMD Opteron 4200 Series'       }
    if($Fam -eq 063) {$F = 'AMD FX Series Processor'       } if($Fam -eq 064) {$F = 'MIPS Family'                         } if($Fam -eq 065) {$F = 'MIPS R4000'                       } if($Fam -eq 066) {$F = 'MIPS R4200'                    }
    if($Fam -eq 067) {$F = 'MIPS R4400'                    } if($Fam -eq 068) {$F = 'MIPS R4600'                          } if($Fam -eq 069) {$F = 'MIPS R10000'                      } if($Fam -eq 070) {$F = 'AMD C-Series'                  }
    if($Fam -eq 071) {$F = 'AMD E-Series'                  } if($Fam -eq 072) {$F = 'AMD A-Series'                        } if($Fam -eq 073) {$F = 'AMD G-Series'                     } if($Fam -eq 074) {$F = 'AMD Z-Series'                  }
    if($Fam -eq 080) {$F = 'SPARC Family'                  } if($Fam -eq 081) {$F = 'SuperSPARC'                          } if($Fam -eq 082) {$F = 'microSPARC II'                    } if($Fam -eq 083) {$F = 'microSPARC IIep'               }
    if($Fam -eq 084) {$F = 'UltraSPARC'                    } if($Fam -eq 085) {$F = 'UltraSPARC II'                       } if($Fam -eq 086) {$F = 'UltraSPARC IIi'                   } if($Fam -eq 087) {$F = 'UltraSPARC III'                }
    if($Fam -eq 088) {$F = 'UltraSPARC IIIi'               } if($Fam -eq 096) {$F = '68040'                               } if($Fam -eq 097) {$F = '68xxx Family'                     } if($Fam -eq 098) {$F = '68000'                         } 
    if($Fam -eq 099) {$F = '68010'                         } if($Fam -eq 100) {$F = '68020'                               } if($Fam -eq 101) {$F = '68030'                            } if($Fam -eq 112) {$F = 'Hobbit Family'                 }
    if($Fam -eq 120) {$F = 'Crusoe TM5000'                 } if($Fam -eq 121) {$F = 'Crusoe TM3000'                       } if($Fam -eq 122) {$F = 'Efficeon TM8000'                  } if($Fam -eq 128) {$F = 'Weitek'                        }
    if($Fam -eq 130) {$F = 'Itanium Processor'             } if($Fam -eq 131) {$F = 'AMD Athlon 64'                       } if($Fam -eq 132) {$F = 'AMD Opteron'                      } if($Fam -eq 133) {$F = 'AMD Sempron'                   }
    if($Fam -eq 134) {$F = 'AMD Turion 64 Mobile'          } if($Fam -eq 135) {$F = 'Dual-Core AMD Opteron'               } if($Fam -eq 136) {$F = 'AMD Athlon 64 X2 Dual-Core'       } if($Fam -eq 137) {$F = 'AMD Turion 64 X2 Mobile'       }
    if($Fam -eq 138) {$F = 'Quad-Core AMD Opteron'         } if($Fam -eq 139) {$F = 'Third-Generation AMD Opteron'        } if($Fam -eq 140) {$F = 'AMD Phenom FX Quad-Core'          } if($Fam -eq 141) {$F = 'AMD Phenom X4 Quad-Core'       }
    if($Fam -eq 142) {$F = 'AMD Phenom X2 Dual-Core'       } if($Fam -eq 143) {$F = 'AMD Athlon X2 Dual-Core'             } if($Fam -eq 144) {$F = 'PA-RISC Family'                   } if($Fam -eq 145) {$F = 'PA-RISC 8500'                  }
    if($Fam -eq 146) {$F = 'PA-RISC 8000'                  } if($Fam -eq 147) {$F = 'PA-RISC 7300LC'                      } if($Fam -eq 148) {$F = 'PA-RISC 7200'                     } if($Fam -eq 149) {$F = 'PA-RISC 7100LC'                }
    if($Fam -eq 150) {$F = 'PA-RISC 7100'                  } if($Fam -eq 160) {$F = 'V30 Family'                          } if($Fam -eq 161) {$F = 'Quad-Core Intel Xeon 3200 Series' } if($Fam -eq 162) {$F = 'Dual-Core Intel Xeon 3000'     }
    if($Fam -eq 163) {$F = 'Quad-Core Intel Xeon 5300'     } if($Fam -eq 164) {$F = 'Dual-Core Intel Xeon 5100 Series'    } if($Fam -eq 165) {$F = 'Dual-Core Intel Xeon 5000 Series' } if($Fam -eq 166) {$F = 'Dual-Core Intel Xeon LV'       }
    if($Fam -eq 167) {$F = 'Dual-Core Intel Xeon ULV'      } if($Fam -eq 168) {$F = 'Dual-Core Intel Xeon 7100 Series'    } if($Fam -eq 169) {$F = 'Quad-Core Intel Xeon 5400 Series' } if($Fam -eq 170) {$F = 'Quad-Core Intel Xeon'          }
    if($Fam -eq 171) {$F = 'Dual-Core Intel Xeon 5200'     } if($Fam -eq 172) {$F = 'Dual-Core Intel Xeon 7200 Series'    } if($Fam -eq 173) {$F = 'Quad-Core Intel Xeon 7300 Series' } if($Fam -eq 174) {$F = 'Quad-Core Intel Xeon 7400'     }
    if($Fam -eq 175) {$F = 'Multi-Core Intel Xeon 7400'    } if($Fam -eq 176) {$F = 'Pentium III Xeon'                    } if($Fam -eq 177) {$F = 'Pentium III with SpeedStep'       } if($Fam -eq 178) {$F = 'Pentium 4'                     }
    if($Fam -eq 179) {$F = 'Intel Xeon'                    } if($Fam -eq 180) {$F = 'AS400 Family'                        } if($Fam -eq 181) {$F = 'Intel Xeon Processor MP'          } if($Fam -eq 182) {$F = 'AMD Athlon XP Family'          }
    if($Fam -eq 183) {$F = 'AMD Athlon MP Family'          } if($Fam -eq 184) {$F = 'Intel Itanium 2'                     } if($Fam -eq 185) {$F = 'Intel Pentium M '                 } if($Fam -eq 186) {$F = 'Intel Celeron D '              }
    if($Fam -eq 187) {$F = 'Intel Pentium D '              } if($Fam -eq 188) {$F = 'Intel Pentium Extreme Edition'       } if($Fam -eq 189) {$F = 'Intel Core Solo'                  } if($Fam -eq 190) {$F = 'K7'                            }
    if($Fam -eq 191) {$F = 'Intel Core2 Duo '              } if($Fam -eq 192) {$F = 'Intel Core2 Solo '                   } if($Fam -eq 193) {$F = 'Intel Core2 Extreme '             } if($Fam -eq 194) {$F = 'Intel Core2 Quad '             }
    if($Fam -eq 195) {$F = 'Intel Core2 Extreme'           } if($Fam -eq 196) {$F = 'Intel Core2 Duo'                     } if($Fam -eq 197) {$F = 'Intel Core2 Solo'                 } if($Fam -eq 198) {$F = 'Intel Core i7'                 }
    if($Fam -eq 199) {$F = 'Dual-Core Intel Celeron'       } if($Fam -eq 200) {$F = 'S/390 and zSeries Family'            } if($Fam -eq 201) {$F = 'ESA/390 G4'                       } if($Fam -eq 202) {$F = 'ESA/390 G5'                    }
    if($Fam -eq 203) {$F = 'ESA/390 G6'                    } if($Fam -eq 204) {$F = 'z/Architectur base'                  } if($Fam -eq 205) {$F = 'Intel Core i5 Processor'          } if($Fam -eq 206) {$F = 'Intel Core i3 Processor'       }
    if($Fam -eq 210) {$F = 'VIA C7-M'                      } if($Fam -eq 211) {$F = 'VIA C7-D'                            } if($Fam -eq 212) {$F = 'VIA C7'                           } if($Fam -eq 213) {$F = 'VIA Eden'                      }
    if($Fam -eq 214) {$F = 'Multi-Core Intel Xeon'         } if($Fam -eq 215) {$F = 'Dual-Core Intel Xeon Processor 3xxx' } if($Fam -eq 216) {$F = 'Quad-Core Intel Xeon 3xxx'        } if($Fam -eq 217) {$F = 'VIA Nano'                      }
    if($Fam -eq 218) {$F = 'Dual-Core Intel Xeon 5xxx'     } if($Fam -eq 219) {$F = 'Quad-Core Intel Xeon Processor 5xxx' } if($Fam -eq 221) {$F = 'Dual-Core Intel Xeon 7xxx'        } if($Fam -eq 222) {$F = 'Quad-Core Intel Xeon 7xxx'     }
    if($Fam -eq 223) {$F = 'Multi-Core Intel Xeon 7xxx'    } if($Fam -eq 224) {$F = 'Multi-Core Intel Xeon Processor 3400'} if($Fam -eq 228) {$F = 'AMD Opteron 3000 Series Processor'} if($Fam -eq 229) {$F = 'AMD Sempron II'                }
    if($Fam -eq 230) {$F = 'Embedded AMD Opteron Quad-Core'} if($Fam -eq 231) {$F = 'AMD Phenom Triple-Core'              } if($Fam -eq 232) {$F = 'AMD Turion Ultra Dual-Core Mobile'} if($Fam -eq 233) {$F = 'AMD Turion Dual-Core Mobile'   }
    if($Fam -eq 234) {$F = 'AMD Athlon Dual-Core'          } if($Fam -eq 235) {$F = 'AMD Sempron SI'                      } if($Fam -eq 236) {$F = 'AMD Phenom II'                    } if($Fam -eq 237) {$F = 'AMD Athlon II'                 }
    if($Fam -eq 238) {$F = 'Six-Core AMD Opteron'          } if($Fam -eq 239) {$F = 'AMD Sempron M'                       } if($Fam -eq 250) {$F = 'i860'                             } if($Fam -eq 251) {$F = 'i960'                          }
    if($Fam -eq 260) {$F = 'SH-3'                          } if($Fam -eq 261) {$F = 'SH-4'                                } if($Fam -eq 280) {$F = 'ARM'                              } if($Fam -eq 281) {$F = 'StrongARM'                     }
    if($Fam -eq 300) {$F = '6x86'                          } if($Fam -eq 301) {$F = 'MediaGX'                             } if($Fam -eq 302) {$F = 'MII'                              } if($Fam -eq 320) {$F = 'WinChip'                       }
    if($Fam -eq 350) {$F = 'DSP'                           } if($Fam -eq 500) {$F = 'Video Processor'                     }

    Return $F
}
#..............................................................................

#..............................................................................
Function Get-CPUStatus($CPUStatus)
{
    $Result = "Undefined Value"
    
    if ($CPUStatus -eq 0) {$Result = 'Unknown'                            }
    if ($CPUStatus -eq 1) {$Result = 'CPU Enabled'                        }
    if ($CPUStatus -eq 2) {$Result = 'CPU Disabled by User via BIOS Setup'}
    if ($CPUStatus -eq 3) {$Result = 'CPU Disabled By BIOS (POST Error)'  }
    if ($CPUStatus -eq 4) {$Result = 'CPU is Idle'                        }
    if ($CPUStatus -eq 7) {$Result = 'Other'                              }
    
    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-StatusInfo($StatusInfo)
{
    $Result = "Undefined Value"
    
    if ($StatusInfo -eq 1) {$Result = 'Other'         }
    if ($StatusInfo -eq 2) {$Result = 'Unknown'       }
    if ($StatusInfo -eq 3) {$Result = 'Enabled'       }
    if ($StatusInfo -eq 4) {$Result = 'Disabled'      }
    if ($StatusInfo -eq 5) {$Result = 'Not Applicable'}

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-Availability($Availability)
{
    $Result = "Undefined Value"
    
    if ($Availability -eq 01  ) {$Result = 'Other'                      }
    if ($Availability -eq 02  ) {$Result = 'Unknown'                    }
    if ($Availability -eq 03  ) {$Result = 'Running/Full Power'         }
    if ($Availability -eq 04  ) {$Result = 'Warning'                    }
    if ($Availability -eq 05  ) {$Result = 'In Test'                    }
    if ($Availability -eq 06  ) {$Result = 'Not Applicable'             }
    if ($Availability -eq 07  ) {$Result = 'Power Off'                  }
    if ($Availability -eq 08  ) {$Result = 'Off Line'                   }
    if ($Availability -eq 09  ) {$Result = 'Off Duty'                   }
    if ($Availability -eq 10  ) {$Result = 'Degraded'                   }
    if ($Availability -eq 11  ) {$Result = 'Not Installed'              }
    if ($Availability -eq 12  ) {$Result = 'Install Error'              }
    if ($Availability -eq 13  ) {$Result = 'Power Save - Unknown'       }
    if ($Availability -eq 14  ) {$Result = 'Power Save - Low Power Mode'}
    if ($Availability -eq 15  ) {$Result = 'Power Save - Standby'       }
    if ($Availability -eq 16  ) {$Result = 'Power Cycle'                }
    if ($Availability -eq 17  ) {$Result = 'Power Save - Warning'       }
    if ($Availability -eq 18  ) {$Result = 'Paused'                     }
    if ($Availability -eq 19  ) {$Result = 'Not Ready'                  }
    if ($Availability -eq 20  ) {$Result = 'Not Configured'             }
    if ($Availability -eq 21  ) {$Result = 'Quiesced'                   }

    Return $Result
}                       
#..............................................................................

#..............................................................................
Function Get-Architecture($Architecture)
{
    $Result = "Undefined Value"
    
    if ($Architecture -eq 0  ) {$Result = 'x86'    }
    if ($Architecture -eq 1  ) {$Result = 'MIPS'   }
    if ($Architecture -eq 2  ) {$Result = 'Alpha'  }
    if ($Architecture -eq 3  ) {$Result = 'PowerPC'}
    if ($Architecture -eq 6  ) {$Result = 'ia64'   }
    if ($Architecture -eq 9  ) {$Result = 'x64'    }

    Return $Result
}                       
#..............................................................................

#..............................................................................
Function Get-MemoryTypeDetail($TypeDetail)
{
    $Result = "Undefined Value"
    
    if ($TypeDetail -eq 1   ) {$Result = "Reserved"     }
                        
    Return $Result
}                       
#..............................................................................

#..............................................................................
Function Convert-BytesToSize
{
    [CmdletBinding()]
    Param([parameter(Mandatory=$False,Position=0)]$Size)
    
    $Result = $null

    if(($Size -gt 1PB)                     ) {$NewSize = $([math]::Round(($Size / 1PB),2)); $Result = $NewSize.ToString() + "PB"}
    if(($Size -gt 1TB) -and ($Size -lt 1PB)) {$NewSize = $([math]::Round(($Size / 1TB),2)); $Result = $NewSize.ToString() + "TB"}
    if(($Size -gt 1GB) -and ($Size -lt 1TB)) {$NewSize = $([math]::Round(($Size / 1GB),2)); $Result = $NewSize.ToString() + "GB"}
    if(($Size -gt 1MB) -and ($Size -lt 1GB)) {$NewSize = $([math]::Round(($Size / 1MB),2)); $Result = $NewSize.ToString() + "MB"}
    if(($Size -gt 1KB) -and ($Size -lt 1MB)) {$NewSize = $([math]::Round(($Size / 1KB),2)); $Result = $NewSize.ToString() + "KB"}

    if ($Result-eq $null)
    {
        $NewSize = $([math]::Round($Size,2))
        $Result = $NewSize.ToString() + " Bytes"
    }

    Return $Result
}
#..............................................................................

#..............................................................................
function Get-MemoryType($MemoryType)
{
    $Result = "Undefined Value"
    
    if ($MemoryType -eq 0  ) {$Result = "Unknown"         }

    Return $Result
}
#..............................................................................

#..............................................................................
Function Get-TotalCoreCount($Processors)
{
    $TotalCoreCount = 0;

    foreach($Processor in $Processors)
    {
        $TotalCoreCount = $TotalCoreCount + $Processor.NumberOfCores
    }

    Return $TotalCoreCount
}
#..............................................................................

#..............................................................................
Function Get-LogicalProcessorCount($Processors)
{
    $LogicalProcessorCount = 0;

    foreach($Processor in $Processors)
    {
        $LogicalProcessorCount = $LogicalProcessorCount + $Processor.NumberOfLogicalProcessors
    }

    Return $LogicalProcessorCount
}
#..............................................................................

#..............................................................................
Function Get-ProcessorCount($Processors)
{
    if ($Processors.Length -gt 1)
    {
        Return $Processors.Length
    }
    else
    {
        Return 1
    }
}
#..............................................................................

#..............................................................................
$Processors = Get-WMIObject Win32_Processor

$TotalPhysicalProcessors = Get-ProcessorCount       ($Processors)
$TotalCores              = Get-TotalCoreCount       ($Processors)
$TotalLogicalProcessors  = Get-LogicalProcessorCount($Processors)

$Today         = Get-Date -UFormat "%Y-%m-%d %H:%M:%S"

$ProcessorInfo  = New-Object Object

$ProcessorInfoTemp = @{}

$ProcessorInfo = {$ProcessorInfoTemp}.Invoke()

$ProcessorInfo.Add("========================================"              )
$ProcessorInfo.Add("System Processor Report"                               )
$ProcessorInfo.Add("========================================"              )
$ProcessorInfo.Add(""                                                      )
$ProcessorInfo.Add("================================"                      )
$ProcessorInfo.Add("Report Summary"                                        )
$ProcessorInfo.Add("--------------------------------"                      )
$ProcessorInfo.Add("Computer Name: " + $Env:COMPUTERNAME                       )
$ProcessorInfo.Add("WMI Class    : Win32_Processor "                       )
$ProcessorInfo.Add("Report Date  : " + $Today                              )
$ProcessorInfo.Add("--------------------------------"                      )
$ProcessorInfo.Add(""                                                      )
$ProcessorInfo.Add("======================="                               )
$ProcessorInfo.Add("Processor Summary"                                     )
$ProcessorInfo.Add("-----------------------"                               )
$ProcessorInfo.Add("Physical Processors: " + $TotalPhysicalProcessors      )
$ProcessorInfo.Add("Physical Cores     : " + $TotalCores                   )
$ProcessorInfo.Add("Logical Processors : " + $TotalLogicalProcessors       )
$ProcessorInfo.Add("======================="                               )

$ProcessorID = 0

Foreach ($Processor in $Processors)
{
    $ProcessorID ++

    $CurrentVoltage = ($Processor.CurrentVoltage/10).ToString("0.0")

    $Availability   = Get-Availability ($Processor.Availability  )
    $Architecture   = Get-Architecture ($Processor.Architecture  )
    $CPUStatus      = Get-CPUStatus    ($Processor.CpuStatus     )
    $Family         = Get-CpuFamily    ($Processor.Family        )
    $ProcessorType  = Get-ProcessorType($Processor.ProcessorType )
    $StatusInfo     = Get-StatusInfo   ($Processor.StatusInfo    )
    $UpgradeMethod  = Get-UpgradeMethod($Processor.UpgradeMethod )

    $ProcessorInfo.Add("")
    $ProcessorInfo.Add("===================================="                                                 )
    $ProcessorInfo.Add("Processor " + $ProcessorID.ToString() + ": " + $Processor.Caption                     )
    $ProcessorInfo.Add("------------------------------------"                                                 )

    $ProcessorInfo.Add("Address Width                          : "  + $Processor.AddressWidth      + " Bits"  )
    $ProcessorInfo.Add("Architecture                           : "  + $Architecture                           )
    $ProcessorInfo.Add("Asset Tag                              : "  + $Processor.AssetTag                     )
    $ProcessorInfo.Add("Availability                           : "  + $Availability                           )
    $ProcessorInfo.Add("Caption                                : "  + $Processor.Caption                      )
    $ProcessorInfo.Add("Class Path                             : "  + $Processor.ClassPath                    )
    $ProcessorInfo.Add("CPU Status                             : "  + $CpuStatus                              )
    $ProcessorInfo.Add("Creation Class Name                    : "  + $Processor.CreationClassName            )
    $ProcessorInfo.Add("Current Clock Speed                    : "  + $Processor.CurrentClockSpeed + " MHz"   )
    $ProcessorInfo.Add("Current Voltage                        : "  + $CurrentVoltage              + "V"      )
    $ProcessorInfo.Add("Data Width                             : "  + $Processor.DataWidth         + " Bits"  )
    $ProcessorInfo.Add("Description                            : "  + $Processor.Description                  )
    $ProcessorInfo.Add("Device ID                              : "  + $Processor.DeviceID                     )
    $ProcessorInfo.Add("Ext Clock                              : "  + $Processor.ExtClock          + " MHz"   )
    $ProcessorInfo.Add("Family                                 : "  + $Family                                 )
    $ProcessorInfo.Add("L2 Cache Size                          : "  + $Processor.L2CacheSize       + " KB"    )
    $ProcessorInfo.Add("L3 Cache Size                          : "  + $Processor.L3CacheSize       + " KB"    )
    $ProcessorInfo.Add("Level                                  : "  + $Processor.Level                        )
    $ProcessorInfo.Add("Load Percentage                        : "  + $Processor.LoadPercentage               )
    $ProcessorInfo.Add("Manufacturer                           : "  + $Processor.Manufacturer                 )
    $ProcessorInfo.Add("Max Clock Speed                        : "  + $Processor.MaxClockSpeed     + " MHz"   )
    $ProcessorInfo.Add("Name                                   : "  + $Processor.Name                         )
    $ProcessorInfo.Add("Number of Cores                        : "  + $Processor.NumberOfCores                )
    $ProcessorInfo.Add("Number of Enabled Cores                : "  + $Processor.NumberOfEnabledCore          )
    $ProcessorInfo.Add("Number of Logical Processors           : "  + $Processor.NumberOfLogicalProcessors    )
    $ProcessorInfo.Add("Part Number                            : "  + $Processor.PartNumber                   )
    $ProcessorInfo.Add("Path                                   : "  + $Processor.Path                         )
    $ProcessorInfo.Add("Power Management Supported             : "  + $Processor.PowerManagementSupported     )
    $ProcessorInfo.Add("Processor ID                           : "  + $Processor.ProcessorId                  )
    $ProcessorInfo.Add("Processor Type                         : "  + $ProcessorType                          )
    $ProcessorInfo.Add("Revision                               : "  + $Processor.Revision                     )
    $ProcessorInfo.Add("Role                                   : "  + $Processor.Role                         )
    $ProcessorInfo.Add("Serial Number                          : "  + $Processor.SerialNumber                 )
    $ProcessorInfo.Add("Socket Designation                     : "  + $Processor.SocketDesignation            )
    $ProcessorInfo.Add("Status                                 : "  + $Processor.Status                       )
    $ProcessorInfo.Add("StatusInfo                             : "  + $StatusInfo                             )
    $ProcessorInfo.Add("SystemCreation Class Name              : "  + $Processor.SystemCreationClassName      )
    $ProcessorInfo.Add("ThreadCount                            : "  + $Processor.ThreadCount                  )
    $ProcessorInfo.Add("UpgradeMethod                          : "  + $UpgradeMethod                          )
    $ProcessorInfo.Add("Virtualization Firmware Enabled        : "  + $Processor.VirtualizationFirmwareEnabled)
    $ProcessorInfo.Add("VM Monitor Mode Extensions             : "  + $Processor.VMMonitorModeExtensions      )
    $ProcessorInfo.Add("------------------------------------"                 )
    $ProcessorInfo.Add(""                                                     )

}

$ProcessorInfo | Out-File "Processor-Details.txt"
