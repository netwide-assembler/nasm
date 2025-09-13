;Testname=avx10.1; Arguments=-fbin -oavx10.1.bin -O0 -DSRC; Files=stdout stderr avx10.1.bin

%macro testcase 2
 %ifdef BIN
  db %1
 %endif
 %ifdef SRC
  %2
 %endif
%endmacro


		bits 64
testcase	{ 0x62, 0xf5, 0x6c, 0x08, 0x5f, 0xcb                                     }, { vmaxph xmm1,xmm2,xmm3                                        }
testcase	{ 0x62, 0xf5, 0x6c, 0x28, 0x5f, 0xcb                                     }, { vmaxph ymm1,ymm2,ymm3                                        }
testcase	{ 0x62, 0xf5, 0x6c, 0x48, 0x5f, 0xcb                                     }, { vmaxph zmm1,zmm2,zmm3                                        }
testcase	{ 0x62, 0xb5, 0x6c, 0x08, 0x5f, 0x4c, 0xf0, 0x01                         }, { vmaxph xmm1,xmm2,[rax+r14*8+0x10]                            }
testcase	{ 0x62, 0xb5, 0x6c, 0x28, 0x5f, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vmaxph ymm1,ymm2,[rax+r14*8+0x10]                            }
testcase	{ 0x62, 0xb5, 0x6c, 0x48, 0x5f, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vmaxph zmm1,zmm2,[rax+r14*8+0x10]                            }

testcase	{ 0x62, 0xf5, 0x6c, 0x08, 0x5d, 0xcb                                     }, { vminph xmm1,xmm2,xmm3                                        }
testcase	{ 0x62, 0xf5, 0x6c, 0x28, 0x5d, 0xcb                                     }, { vminph ymm1,ymm2,ymm3                                        }
testcase	{ 0x62, 0xf5, 0x6c, 0x48, 0x5d, 0xcb                                     }, { vminph zmm1,zmm2,zmm3                                        }
testcase	{ 0x62, 0xb5, 0x6c, 0x08, 0x5d, 0x4c, 0xf0, 0x01                         }, { vminph xmm1,xmm2,[rax+r14*8+0x10]                            }
testcase	{ 0x62, 0xb5, 0x6c, 0x28, 0x5d, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vminph ymm1,ymm2,[rax+r14*8+0x10]                            }
testcase	{ 0x62, 0xb5, 0x6c, 0x48, 0x5d, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vminph zmm1,zmm2,[rax+r14*8+0x10]                            }

testcase	{ 0x62, 0xf3, 0x7c, 0x08, 0x08, 0xca, 0x0a                               }, { vrndscaleph xmm1,xmm2,10                                     }
testcase	{ 0x62, 0xf3, 0x7c, 0x28, 0x08, 0xca, 0x0a                               }, { vrndscaleph ymm1,ymm2,10                                     }
testcase	{ 0x62, 0xf3, 0x7c, 0x48, 0x08, 0xca, 0x0a                               }, { vrndscaleph zmm1,zmm2,10                                     }
testcase	{ 0x62, 0xf3, 0x7c, 0x89, 0x08, 0xca, 0x0a                               }, { vrndscaleph xmm1{k1}{z},xmm2,10                              }
testcase	{ 0x62, 0xf3, 0x7c, 0xa9, 0x08, 0xca, 0x0a                               }, { vrndscaleph ymm1{k1}{z},ymm2,10                              }
testcase	{ 0x62, 0xf3, 0x7c, 0xc9, 0x08, 0xca, 0x0a                               }, { vrndscaleph zmm1{k1}{z},zmm2,10                              }

testcase	{ 0x62, 0xf3, 0x6c, 0x08, 0x0a, 0xcb, 0x0a                               }, { vrndscalesh xmm1,xmm2,xmm3,10                                }
testcase	{ 0x62, 0xf3, 0x6c, 0x89, 0x0a, 0xcb, 0x0a                               }, { vrndscalesh xmm1{k1}{z},xmm2,xmm3,10                         }
testcase	{ 0x62, 0xf3, 0x6c, 0x99, 0x0a, 0xcb, 0x0a                               }, { vrndscalesh xmm1{k1}{z},xmm2,xmm3,{sae},10                   }

testcase	{ 0x62, 0xf5, 0x7d, 0x08, 0x1d, 0xca                                     }, { vcvtps2phx xmm1,xmm2                                         }
testcase	{ 0x62, 0xf5, 0x7d, 0x28, 0x1d, 0xca                                     }, { vcvtps2phx xmm1,ymm2                                         }
testcase	{ 0x62, 0xb5, 0x7d, 0x08, 0x1d, 0x4c, 0xf0, 0x01                         }, { vcvtps2phx xmm1,[rax+r14*8+0x10]                             }
testcase	{ 0x62, 0xf5, 0x7d, 0x48, 0x1d, 0xca                                     }, { vcvtps2phx ymm1,zmm2                                         }
testcase	{ 0x62, 0xb5, 0x7d, 0x48, 0x1d, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vcvtps2phx ymm1,[rax+r14*8+0x10]                             }
testcase	{ 0x62, 0xb5, 0x7d, 0xc9, 0x1d, 0x8c, 0xf0, 0x10, 0x00, 0x00, 0x00       }, { vcvtps2phx ymm1{k1}{z},[rax+r14*8+0x10]                      }

testcase        {  0x62, 0xf5, 0x74, 0x08, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1, xmm1, xmm1                                       }
testcase        {  0x62, 0xf5, 0x74, 0x0f, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1{k7}, xmm1, xmm1                                   }
testcase        {  0x62, 0xf5, 0x74, 0x0f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}, xmm1, oword [rax]                            }
testcase        {  0x62, 0xb5, 0x74, 0x0f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1{k7}, xmm1, oword [rbp+r14*2+0x8]                  }
testcase        {  0x62, 0xf5, 0x74, 0x1f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}, xmm1, word [rax]{1to8}                       }
testcase        {  0x62, 0xb5, 0x74, 0x1f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1{k7}, xmm1, word [rbp+r14*2+0x8]{1to8}             }
testcase        {  0x62, 0xf5, 0x74, 0x0f, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1{k7}, xmm1                                         }
testcase        {  0x62, 0xf5, 0x74, 0x0f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}, oword [rax]                                  }
testcase        {  0x62, 0xb5, 0x74, 0x0f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1{k7}, oword [rbp+r14*2+0x8]                        }
testcase        {  0x62, 0xf5, 0x74, 0x1f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}, word [rax]{1to8}                             }
testcase        {  0x62, 0xb5, 0x74, 0x1f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1{k7}, word [rbp+r14*2+0x8]{1to8}                   }
testcase        {  0x62, 0xf5, 0x74, 0x08, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1, xmm1, oword [rax]                                }
testcase        {  0x62, 0xf5, 0x74, 0x8f, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1{k7}{z}, xmm1, xmm1                                }
testcase        {  0x62, 0xf5, 0x74, 0x8f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}{z}, xmm1, oword [rax]                         }
testcase        {  0x62, 0xb5, 0x74, 0x8f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1{k7}{z}, xmm1, oword [rbp+r14*2+0x8]               }
testcase        {  0x62, 0xf5, 0x74, 0x9f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}{z}, xmm1, word [rax]{1to8}                    }
testcase        {  0x62, 0xb5, 0x74, 0x9f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1{k7}{z}, xmm1, word [rbp+r14*2+0x8]{1to8}          }
testcase        {  0x62, 0xf5, 0x74, 0x8f, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1{k7}{z}, xmm1                                      }
testcase        {  0x62, 0xf5, 0x74, 0x8f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}{z}, oword [rax]                               }
testcase        {  0x62, 0xb5, 0x74, 0x8f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1{k7}{z}, oword [rbp+r14*2+0x8]                     }
testcase        {  0x62, 0xf5, 0x74, 0x9f, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1{k7}{z}, word [rax]{1to8}                          }
testcase        {  0x62, 0xb5, 0x74, 0x9f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1{k7}{z}, word [rbp+r14*2+0x8]{1to8}                }
testcase        {  0x62, 0xb5, 0x74, 0x08, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1, xmm1, oword [rbp+r14*2+0x8]                      }
testcase        {  0x62, 0xf5, 0x74, 0x28, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1, ymm1, ymm1                                       }
testcase        {  0x62, 0xf5, 0x74, 0x28, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1, ymm1, yword [rax]                                }
testcase        {  0x62, 0xb5, 0x74, 0x28, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1, ymm1, yword [rbp+r14*2+0x8]                      }
testcase        {  0x62, 0xf5, 0x74, 0x38, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1, ymm1, word [rax]{1to16}                          }
testcase        {  0x62, 0xb5, 0x74, 0x38, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1, ymm1, word [rbp+r14*2+0x8]{1to16}                }
testcase        {  0x62, 0xf5, 0x74, 0x28, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1, ymm1                                             }
testcase        {  0x62, 0xf5, 0x74, 0x28, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1, yword [rax]                                      }
testcase        {  0x62, 0xb5, 0x74, 0x28, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1, yword [rbp+r14*2+0x8]                            }
testcase        {  0x62, 0xf5, 0x74, 0x38, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1, word [rax]{1to16}                                }
testcase        {  0x62, 0xb5, 0x74, 0x38, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1, word [rbp+r14*2+0x8]{1to16}                      }
testcase        {  0x62, 0xf5, 0x74, 0x18, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1, xmm1, word [rax]{1to8}                           }
testcase        {  0x62, 0xf5, 0x74, 0x2f, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1{k7}, ymm1, ymm1                                   }
testcase        {  0x62, 0xf5, 0x74, 0x2f, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}, ymm1, yword [rax]                            }
testcase        {  0x62, 0xb5, 0x74, 0x2f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1{k7}, ymm1, yword [rbp+r14*2+0x8]                  }
testcase        {  0x62, 0xf5, 0x74, 0x3f, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}, ymm1, word [rax]{1to16}                      }
testcase        {  0x62, 0xb5, 0x74, 0x3f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1{k7}, ymm1, word [rbp+r14*2+0x8]{1to16}            }
testcase        {  0x62, 0xf5, 0x74, 0x2f, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1{k7}, ymm1                                         }
testcase        {  0x62, 0xf5, 0x74, 0x2f, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}, yword [rax]                                  }
testcase        {  0x62, 0xb5, 0x74, 0x2f, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1{k7}, yword [rbp+r14*2+0x8]                        }
testcase        {  0x62, 0xf5, 0x74, 0x3f, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}, word [rax]{1to16}                            }
testcase        {  0x62, 0xb5, 0x74, 0x3f, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1{k7}, word [rbp+r14*2+0x8]{1to16}                  }
testcase        {  0x62, 0xb5, 0x74, 0x18, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1, xmm1, word [rbp+r14*2+0x8]{1to8}                 }
testcase        {  0x62, 0xf5, 0x74, 0xaf, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1{k7}{z}, ymm1, ymm1                                }
testcase        {  0x62, 0xf5, 0x74, 0xaf, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}{z}, ymm1, yword [rax]                         }
testcase        {  0x62, 0xb5, 0x74, 0xaf, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1{k7}{z}, ymm1, yword [rbp+r14*2+0x8]               }
testcase        {  0x62, 0xf5, 0x74, 0xbf, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}{z}, ymm1, word [rax]{1to16}                   }
testcase        {  0x62, 0xb5, 0x74, 0xbf, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1{k7}{z}, ymm1, word [rbp+r14*2+0x8]{1to16}         }
testcase        {  0x62, 0xf5, 0x74, 0xaf, 0x58, 0xc9                                        }, {        {evex} VADDPH ymm1{k7}{z}, ymm1                                      }
testcase        {  0x62, 0xf5, 0x74, 0xaf, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}{z}, yword [rax]                               }
testcase        {  0x62, 0xb5, 0x74, 0xaf, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH ymm1{k7}{z}, yword [rbp+r14*2+0x8]                     }
testcase        {  0x62, 0xf5, 0x74, 0xbf, 0x58, 0x08                                        }, {        {evex} VADDPH ymm1{k7}{z}, word [rax]{1to16}                         }
testcase        {  0x62, 0xb5, 0x74, 0xbf, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH ymm1{k7}{z}, word [rbp+r14*2+0x8]{1to16}               }
testcase        {  0x62, 0xf5, 0x74, 0x08, 0x58, 0xc9                                        }, {        {evex} VADDPH xmm1, xmm1                                             }
testcase        {  0x62, 0xf5, 0x7c, 0x48, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0, zmm0, zmm1                                       }
testcase        {  0x62, 0xf5, 0x7c, 0x48, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0, zmm0, zword [rax]                                }
testcase        {  0x62, 0xb5, 0x7c, 0x48, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0, zmm0, zword [rbp+r14*2+0x8]                      }
testcase        {  0x62, 0xf5, 0x7c, 0x38, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0, zmm0, zmm1,{rd-sae}                              }
testcase        {  0x62, 0xf5, 0x7c, 0x48, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0, zmm1                                             }
testcase        {  0x62, 0xf5, 0x7c, 0x48, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0, zword [rax]                                      }
testcase        {  0x62, 0xb5, 0x7c, 0x48, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0, zword [rbp+r14*2+0x8]                            }
testcase        {  0x62, 0xf5, 0x7c, 0x38, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0, zmm1,{rd-sae}                                    }
testcase        {  0x62, 0xf5, 0x7c, 0x4f, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}, zmm0, zmm1                                   }
testcase        {  0x62, 0xf5, 0x7c, 0x4f, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0{k7}, zmm0, zword [rax]                            }
testcase        {  0x62, 0xf5, 0x74, 0x08, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1, oword [rax]                                      }
testcase        {  0x62, 0xb5, 0x7c, 0x4f, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0{k7}, zmm0, zword [rbp+r14*2+0x8]                  }
testcase        {  0x62, 0xf5, 0x7c, 0x3f, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}, zmm0, zmm1,{rd-sae}                          }
testcase        {  0x62, 0xf5, 0x7c, 0x4f, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}, zmm1                                         }
testcase        {  0x62, 0xf5, 0x7c, 0x4f, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0{k7}, zword [rax]                                  }
testcase        {  0x62, 0xb5, 0x7c, 0x4f, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0{k7}, zword [rbp+r14*2+0x8]                        }
testcase        {  0x62, 0xf5, 0x7c, 0x3f, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}, zmm1,{rd-sae}                                }
testcase        {  0x62, 0xf5, 0x7c, 0xcf, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}{z}, zmm0, zmm1                                }
testcase        {  0x62, 0xf5, 0x7c, 0xcf, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0{k7}{z}, zmm0, zword [rax]                         }
testcase        {  0x62, 0xb5, 0x7c, 0xcf, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0{k7}{z}, zmm0, zword [rbp+r14*2+0x8]               }
testcase        {  0x62, 0xf5, 0x7c, 0xbf, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}{z}, zmm0, zmm1,{rd-sae}                       }
testcase        {  0x62, 0xb5, 0x74, 0x08, 0x58, 0x8c, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH xmm1, oword [rbp+r14*2+0x8]                            }
testcase        {  0x62, 0xf5, 0x7c, 0xcf, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}{z}, zmm1                                      }
testcase        {  0x62, 0xf5, 0x7c, 0xcf, 0x58, 0x00                                        }, {        {evex} VADDPH zmm0{k7}{z}, zword [rax]                               }
testcase        {  0x62, 0xb5, 0x7c, 0xcf, 0x58, 0x84, 0x75, 0x08, 0x00, 0x00, 0x00          }, {        {evex} VADDPH zmm0{k7}{z}, zword [rbp+r14*2+0x8]                     }
testcase        {  0x62, 0xf5, 0x7c, 0xbf, 0x58, 0xc1                                        }, {        {evex} VADDPH zmm0{k7}{z}, zmm1,{rd-sae}                             }
testcase        {  0x62, 0xf5, 0x74, 0x18, 0x58, 0x08                                        }, {        {evex} VADDPH xmm1, word [rax]{1to8}                                 }
testcase        {  0x62, 0xb5, 0x74, 0x18, 0x58, 0x4c, 0x75, 0x02                            }, {        {evex} VADDPH xmm1, word [rbp+r14*2+0x8]{1to8}                       }
