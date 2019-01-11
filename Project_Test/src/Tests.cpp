#include "../include/Tests.h"
#include "../include/ProjectTest.h"
#include <iostream>
#include <typeinfo>
#include <fstream>
#include <math.h>
#include <sstream>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <signal.h>

using std::streambuf;
using std::istringstream;
using std::to_string;
using std::cout;
using std::sprintf;
using std::complex;

#define RED   "\e[38;5;196m"
#define GRN   "\e[38;5;082m"
#define YEL   "\e[38;5;226m"
#define MAG   "\e[38;5;201m"
#define RESET "\e[0m"

// Defining Global Variables
vector<string> testsCodes;
std::stringstream ss;
std::streambuf *old_buf;
int abortExecution = 0;
string test_0 = R"V0G0N(
      
)V0G0N";

// Initializing before execution of tests
void Initialize()
{ 
  //change the underlying cout buffer and save the old buffer
  old_buf = std::cout.rdbuf(ss.rdbuf());

  // Catching signal
  signal(SIGINT,sigintHandler);
}

// Finialize after execution of tests
void Finialize()
{    
    // Restoring cout buffer
    std::cout.rdbuf(old_buf);

    // Printing cout output
    std::string text_output = ss.str();
    std::cout << text_output;
}

// Initializing tests to be executed
void InitializingTests()
{
    /* ### Example of use ###

     testsFunctions.push_back();

    */

    // Initializing tests to be executed
    testsFunctions.push_back(FINAL_PROJECT_TEST);

     // Defining tests
    string test_1 = "";
    string test_2 = "(define pro (lambda (x) x))"; //was 5.5
    string test_3 = "#t #f";
    string test_4 = "'()";
    string test_5 = "#\\h";
    string test_6 = "\" hello this is the final project\" 6666 '(5 . 4)";
    string test_7 = "'hellothisisthefinalproject12345678910  \"\\n \\r \\f this is \\n \\r \\f \"  6567 '#(4 5 6 \"\\n \\r \\f this is \\n \\r \\f \") 6 \"\\n \\r \\f this is \\n \\r \\f \"";
    string test_8 = "'(55 . 4.4)";
    string test_9 = "'(55 4.4 \"gotcha\" #t #f #\\tab) #f #t \" hfdgfdgdf454 fgfd\" 'dfdsfdsfds";
    string test_10 = "'#(55 4.4 \"gotcha\" #t #f #\\tab \"\\n \\r \\f this is \\n \\r gfgfdgf 4543543 ff \\f \")";
    string test_11 = /*"5 5.5 #t #f #\\h \" hello this is the final project\" '#() '#(5) '#(5 4) '#(4 5 6) '#(5 6 7 8 9) '() '(5) '(6 7) '(6 6 6 7)"
                    "'hellothisisthefinalproject12345678910 '#(55 4.4 \"gotcha\" "
                    "#t #f #\\tab) '(55 4.4 \"gotcha\" #t #f #\\tab)"*/""; 
    string test_12 = "(define x 5)";
    string test_13 = "(define x 5) x";
    string test_14 = "(if #t #f 5)";
    string test_15 = "(define x 5) (set! x 4) x";
    string test_16 = "(or #f #f #f #f #f #f 5)";
    string test_17 = "(define pro (lambda (x) x))";
    string test_18 = "(define pro (lambda (x) x)) (pro 5)";
    string test_19 = /*"(define pro (lambda (x . y) x)) (pro 5)"*/"";
    string test_20 = /*"(define pro (lambda (x . y) y)) (pro 5 4 3 2 1)*/"";
    string test_21 = /*"(define pro (lambda y y)) (pro 5 4 3 2 1)"*/""; //this fails because this is an optional lamnda!!!!!
    string test_22 = "(define pro 10) pro" 
                     "(define tail 5) tail";
    string test_23 = "(define pro 10) pro pro pro pro pro pro pro";
    string test_24 = "(define pro 10) pro pro pro" 
                     "(define tail 5) pro tail pro";
    string test_25 = "(define pro 10) pro pro pro" 
                     "(define tail 5) tail pro";
    string test_26 = /*"(define pro (lambda (f x) (f x)))" 
                     "(define tail (lambda x x))"
                     "(pro tail 5)*/""; //lambda opt!!!!!
    string test_27 = /*R"V0G0N(   
             (let ((x #f) (y #t))
            (let ((z 1))
            y))     
    )V0G0N"*/
    R"V0G0N(   
                (define proc (lambda (x) 
                                (lambda () x)))   
            ((proc 1))
    )V0G0N";
   
    string test_28 = /*R"V0G0N(   
                ((lambda (x) 6) 6)
                ((lambda (y) 5) 5)
    )V0G0N"*/
    R"V0G0N(   
            (((lambda (x) 
                (lambda () x)) 85))
    )V0G0N";
    string test_29 = R"V0G0N(   
                (define append 
                  (let ((null? null?) (car car) (cdr cdr) (cons cons)) 5))
                
                  (define zero? 
                    (let ((= =))
                      (lambda (x) (= x 0))))
    )V0G0N";
    string test_30 = R"V0G0N(   
                (define proc (lambda (x y z) 
                    (lambda (y u i)  
                    (lambda (d f g) x)
                    )
                ))   
            (((proc 1 2 3) 4 5 6) 7 8 9)
    )V0G0N";
    string test_31 = R"V0G0N(   
            (define foo5
            (lambda (x y)
                (lambda () 
                        "\n \r \f this is \n \r \f "
                        (set! x 5))
                (lambda () x)
            ))

        ((foo5 1 2))   
    )V0G0N";
    string test_32 = R"V0G0N(   
           '#('(4 5) (1 2))                          ; vector with quoted list and non-quoted list     
    )V0G0N";
    string test_33 = R"V0G0N(   
            '#("B" 3 'cake cookie donut pie)                     ; vector with quoted symbol and non-quoted symbol    
    )V0G0N";
    string test_34 = R"V0G0N(   
             '('''a)                                   ; quote madness    
    )V0G0N";
    string test_35 = R"V0G0N(   
             '''''b                                    ; quote madness #2    
              '(1 2 3 4 4 5 6 7 8 9 10 11 12 13 (14 15 (16)) 17 18 19 20) ;115 constants
    )V0G0N";
    string test_36 = R"V0G0N(   
            '("A")                                    ; vector with string - should remain a capital A and not a lowercase a    
    )V0G0N";
    string test_37 = R"V0G0N(   
             'asfgdsfgsdfhgwghrwghwefh1835             ; just a symbol    
    )V0G0N";
    string test_38 = R"V0G0N(   
              "string"                                 ; simple string  
    )V0G0N";
    string test_39 = R"V0G0N(   
                1.3                                    ; fraction 
    )V0G0N";
    string test_40 = R"V0G0N(   
                (if #t 1 2)                               ; if with 'else' clause 
    )V0G0N";
    string test_41 = R"V0G0N(   
                 (if #f 3)                                 ; if without else clause, test evaluates to #f, should return void
    )V0G0N";
    string test_42 = R"V0G0N(   
                 `(1 2 'k)                                 ; quasiquote 
    )V0G0N";
    string test_43 = R"V0G0N(   
                ((lambda (y z) ((lambda ( x w)  (set! y 5) y) 3 4))1 2)
    )V0G0N";
    string test_44 = R"V0G0N(   
                 (begin 1 2 3)                             ; sequence
    )V0G0N";
    string test_45 = R"V0G0N(   
                 (or)                                      ; or without sub-expressions
    )V0G0N";
    string test_46 = R"V0G0N(   
                 (or #f #f 'a)                             ; or with sub-expressions
    )V0G0N";
    string test_47 = R"V0G0N(   

            ; Checking fvar_tbl working correctly 
            
            (define x_0 0)
            (define x_1 1)
            (define x_2 2)
            (define x_3 3)
            (define x_4 4)
            (define x_5 5)
            (define x_6 6)
            (define x_7 7)
            (define x_8 8)
            (define x_9 9)
            (define x_10 10)
            (define x_11 11)
            (define x_12 12)
            (define x_13 13)
            (define x_14 14)
            (define x_15 15)
            (define x_16 16)
            (define x_17 17)
            (define x_18 18)
            (define x_19 19)
            (define x_20 20)
            (define x_21 21)
            (define x_22 22)
            (define x_23 23)
            (define x_24 24)
            (define x_25 25)
            (define x_26 26)
            (define x_27 27)
            (define x_28 28)
            (define x_29 29)
            (define x_30 30)
            (define x_31 31)
            (define x_32 32)
            (define x_33 33)
            (define x_34 34)
            (define x_35 35)
            (define x_36 36)
            (define x_37 37)
            (define x_38 38)
            (define x_39 39)
            (define x_40 40)
            (define x_41 41)
            (define x_42 42)
            (define x_43 43)
            (define x_44 44)
            (define x_45 45)
            (define x_46 46)
            (define x_47 47)
            (define x_48 48)
            (define x_49 49)
            (define x_50 50)
            (define x_51 51)
            (define x_52 52)
            (define x_53 53)
            (define x_54 54)
            (define x_55 55)
            (define x_56 56)
            (define x_57 57)
            (define x_58 58)
            (define x_59 59)
            (define x_60 60)
            (define x_61 61)
            (define x_62 62)
            (define x_63 63)
            (define x_64 64)
            (define x_65 65)
            (define x_66 66)
            (define x_67 67)
            (define x_68 68)
            (define x_69 69)
            (define x_70 70)
            (define x_71 71)
            (define x_72 72)
            (define x_73 73)
            (define x_74 74)
            (define x_75 75)
            (define x_76 76)
            (define x_77 77)
            (define x_78 78)
            (define x_79 79)
            (define x_80 80)
            (define x_81 81)
            (define x_82 82)
            (define x_83 83)
            (define x_84 84)
            (define x_85 85)
            (define x_86 86)
            (define x_87 87)
            (define x_88 88)
            (define x_89 89)
            (define x_90 90)
            (define x_91 91)
            (define x_92 92)
            (define x_93 93)
            (define x_94 94)
            (define x_95 95)
            (define x_96 96)
            (define x_97 97)
            (define x_98 98)
            (define x_99 99)
            (define x_100 100)
            (define x_101 101)
            (define x_102 102)
            (define x_103 103)
            (define x_104 104)
            (define x_105 105)
            (define x_106 106)
            (define x_107 107)
            (define x_108 108)
            (define x_109 109)
            (define x_110 110)
            (define x_111 111)
            (define x_112 112)
            (define x_113 113)
            (define x_114 114)
            (define x_115 115)
            (define x_116 116)
            (define x_117 117)
            (define x_118 118)
            (define x_119 119)
            (define x_120 120)
            (define x_121 121)
            (define x_122 122)
            (define x_123 123)
            (define x_124 124)
            (define x_125 125)
            (define x_126 126)
            (define x_127 127)
            (define x_128 128)
            (define x_129 129)
            (define x_130 130)
            (define x_131 131)
            (define x_132 132)
            (define x_133 133)
            (define x_134 134)
            (define x_135 135)
            (define x_136 136)
            (define x_137 137)
            (define x_138 138)
            (define x_139 139)
            (define x_140 140)
            (define x_141 141)
            (define x_142 142)
            (define x_143 143)
            (define x_144 144)
            (define x_145 145)
            (define x_146 146)
            (define x_147 147)
            (define x_148 148)
            (define x_149 149)
            (define x_150 150)
            (define x_151 151)
            (define x_152 152)
            (define x_153 153)
            (define x_154 154)
            (define x_155 155)
            (define x_156 156)
            (define x_157 157)
            (define x_158 158)
            (define x_159 159)
            (define x_160 160)
            (define x_161 161)
            (define x_162 162)
            (define x_163 163)
            (define x_164 164)
            (define x_165 165)
            (define x_166 166)
            (define x_167 167)
            (define x_168 168)
            (define x_169 169)
            (define x_170 170)
            (define x_171 171)
            (define x_172 172)
            (define x_173 173)
            (define x_174 174)
            (define x_175 175)
            (define x_176 176)
            (define x_177 177)
            (define x_178 178)
            (define x_179 179)
            (define x_180 180)
            (define x_181 181)
            (define x_182 182)
            (define x_183 183)
            (define x_184 184)
            (define x_185 185)
            (define x_186 186)
            (define x_187 187)
            (define x_188 188)
            (define x_189 189)
            (define x_190 190)
            (define x_191 191)
            (define x_192 192)
            (define x_193 193)
            (define x_194 194)
            (define x_195 195)
            (define x_196 196)
            (define x_197 197)
            (define x_198 198)
            (define x_199 199)
            (define x_200 200)
            (define x_201 201)
            (define x_202 202)
            (define x_203 203)
            (define x_204 204)
            (define x_205 205)
            (define x_206 206)
            (define x_207 207)
            (define x_208 208)
            (define x_209 209)
            (define x_210 210)
            (define x_211 211)
            (define x_212 212)
            (define x_213 213)
            (define x_214 214)
            (define x_215 215)
            (define x_216 216)
            (define x_217 217)
            (define x_218 218)
            (define x_219 219)
            (define x_220 220)
            (define x_221 221)
            (define x_222 222)
            (define x_223 223)
            (define x_224 224)
            (define x_225 225)
            (define x_226 226)
            (define x_227 227)
            (define x_228 228)
            (define x_229 229)
            (define x_230 230)
            (define x_231 231)
            (define x_232 232)
            (define x_233 233)
            (define x_234 234)
            (define x_235 235)
            (define x_236 236)
            (define x_237 237)
            (define x_238 238)
            (define x_239 239)
            (define x_240 240)
            (define x_241 241)
            (define x_242 242)
            (define x_243 243)
            (define x_244 244)
            (define x_245 245)
            (define x_246 246)
            (define x_247 247)
            (define x_248 248)
            (define x_249 249)
            (define x_250 250)
            (define x_251 251)
            (define x_252 252)
            (define x_253 253)
            (define x_254 254)
            (define x_255 255)
            (define x_256 256)
            (define x_257 257)
            (define x_258 258)
            (define x_259 259)
            (define x_260 260)
            (define x_261 261)
            (define x_262 262)
            (define x_263 263)
            (define x_264 264)
            (define x_265 265)
            (define x_266 266)
            (define x_267 267)
            (define x_268 268)
            (define x_269 269)
            (define x_270 270)
            (define x_271 271)
            (define x_272 272)
            (define x_273 273)
            (define x_274 274)
            (define x_275 275)
            (define x_276 276)
            (define x_277 277)
            (define x_278 278)
            (define x_279 279)
            (define x_280 280)
            (define x_281 281)
            (define x_282 282)
            (define x_283 283)
            (define x_284 284)
            (define x_285 285)
            (define x_286 286)
            (define x_287 287)
            (define x_288 288)
            (define x_289 289)
            (define x_290 290)
            (define x_291 291)
            (define x_292 292)
            (define x_293 293)
            (define x_294 294)
            (define x_295 295)
            (define x_296 296)
            (define x_297 297)
            (define x_298 298)
            (define x_299 299)
            (define x_300 300)
            (define x_301 301)
            (define x_302 302)
            (define x_303 303)
            (define x_304 304)
            (define x_305 305)
            (define x_306 306)
            (define x_307 307)
            (define x_308 308)
            (define x_309 309)
            (define x_310 310)
            (define x_311 311)
            (define x_312 312)
            (define x_313 313)
            (define x_314 314)
            (define x_315 315)
            (define x_316 316)
            (define x_317 317)
            (define x_318 318)
            (define x_319 319)
            (define x_320 320)
            (define x_321 321)
            (define x_322 322)
            (define x_323 323)
            (define x_324 324)
            (define x_325 325)
            (define x_326 326)
            (define x_327 327)
            (define x_328 328)
            (define x_329 329)
            (define x_330 330)
            (define x_331 331)
            (define x_332 332)
            (define x_333 333)
            (define x_334 334)
            (define x_335 335)
            (define x_336 336)
            (define x_337 337)
            (define x_338 338)
            (define x_339 339)
            (define x_340 340)
            (define x_341 341)
            (define x_342 342)
            (define x_343 343)
            (define x_344 344)
            (define x_345 345)
            (define x_346 346)
            (define x_347 347)
            (define x_348 348)
            (define x_349 349)
            (define x_350 350)
            (define x_351 351)
            (define x_352 352)
            (define x_353 353)
            (define x_354 354)
            (define x_355 355)
            (define x_356 356)
            (define x_357 357)
            (define x_358 358)
            (define x_359 359)
            (define x_360 360)
            (define x_361 361)
            (define x_362 362)
            (define x_363 363)
            (define x_364 364)
            (define x_365 365)
            (define x_366 366)
            (define x_367 367)
            (define x_368 368)
            (define x_369 369)
            (define x_370 370)
            (define x_371 371)
            (define x_372 372)
            (define x_373 373)
            (define x_374 374)
            (define x_375 375)
            (define x_376 376)
            (define x_377 377)
            (define x_378 378)
            (define x_379 379)
            (define x_380 380)
            (define x_381 381)
            (define x_382 382)
            (define x_383 383)
            (define x_384 384)
            (define x_385 385)
            (define x_386 386)
            (define x_387 387)
            (define x_388 388)
            (define x_389 389)
            (define x_390 390)
            (define x_391 391)
            (define x_392 392)
            (define x_393 393)
            (define x_394 394)
            (define x_395 395)
            (define x_396 396)
            (define x_397 397)
            (define x_398 398)
            (define x_399 399)     

            (set! x_0 -0)
            (set! x_1 -1)
            (set! x_2 -2)
            (set! x_3 -3)
            (set! x_4 -4)
            (set! x_5 -5)
            (set! x_6 -6)
            (set! x_7 -7)
            (set! x_8 -8)
            (set! x_9 -9)
            (set! x_10 -10)
            (set! x_11 -11)
            (set! x_12 -12)
            (set! x_13 -13)
            (set! x_14 -14)
            (set! x_15 -15)
            (set! x_16 -16)
            (set! x_17 -17)
            (set! x_18 -18)
            (set! x_19 -19)
            (set! x_20 -20)
            (set! x_21 -21)
            (set! x_22 -22)
            (set! x_23 -23)
            (set! x_24 -24)
            (set! x_25 -25)
            (set! x_26 -26)
            (set! x_27 -27)
            (set! x_28 -28)
            (set! x_29 -29)
            (set! x_30 -30)
            (set! x_31 -31)
            (set! x_32 -32)
            (set! x_33 -33)
            (set! x_34 -34)
            (set! x_35 -35)
            (set! x_36 -36)
            (set! x_37 -37)
            (set! x_38 -38)
            (set! x_39 -39)
            (set! x_40 -40)
            (set! x_41 -41)
            (set! x_42 -42)
            (set! x_43 -43)
            (set! x_44 -44)
            (set! x_45 -45)
            (set! x_46 -46)
            (set! x_47 -47)
            (set! x_48 -48)
            (set! x_49 -49)
            (set! x_50 -50)
            (set! x_51 -51)
            (set! x_52 -52)
            (set! x_53 -53)
            (set! x_54 -54)
            (set! x_55 -55)
            (set! x_56 -56)
            (set! x_57 -57)
            (set! x_58 -58)
            (set! x_59 -59)
            (set! x_60 -60)
            (set! x_61 -61)
            (set! x_62 -62)
            (set! x_63 -63)
            (set! x_64 -64)
            (set! x_65 -65)
            (set! x_66 -66)
            (set! x_67 -67)
            (set! x_68 -68)
            (set! x_69 -69)
            (set! x_70 -70)
            (set! x_71 -71)
            (set! x_72 -72)
            (set! x_73 -73)
            (set! x_74 -74)
            (set! x_75 -75)
            (set! x_76 -76)
            (set! x_77 -77)
            (set! x_78 -78)
            (set! x_79 -79)
            (set! x_80 -80)
            (set! x_81 -81)
            (set! x_82 -82)
            (set! x_83 -83)
            (set! x_84 -84)
            (set! x_85 -85)
            (set! x_86 -86)
            (set! x_87 -87)
            (set! x_88 -88)
            (set! x_89 -89)
            (set! x_90 -90)
            (set! x_91 -91)
            (set! x_92 -92)
            (set! x_93 -93)
            (set! x_94 -94)
            (set! x_95 -95)
            (set! x_96 -96)
            (set! x_97 -97)
            (set! x_98 -98)
            (set! x_99 -99)
            (set! x_100 -100)
            (set! x_101 -101)
            (set! x_102 -102)
            (set! x_103 -103)
            (set! x_104 -104)
            (set! x_105 -105)
            (set! x_106 -106)
            (set! x_107 -107)
            (set! x_108 -108)
            (set! x_109 -109)
            (set! x_110 -110)
            (set! x_111 -111)
            (set! x_112 -112)
            (set! x_113 -113)
            (set! x_114 -114)
            (set! x_115 -115)
            (set! x_116 -116)
            (set! x_117 -117)
            (set! x_118 -118)
            (set! x_119 -119)
            (set! x_120 -120)
            (set! x_121 -121)
            (set! x_122 -122)
            (set! x_123 -123)
            (set! x_124 -124)
            (set! x_125 -125)
            (set! x_126 -126)
            (set! x_127 -127)
            (set! x_128 -128)
            (set! x_129 -129)
            (set! x_130 -130)
            (set! x_131 -131)
            (set! x_132 -132)
            (set! x_133 -133)
            (set! x_134 -134)
            (set! x_135 -135)
            (set! x_136 -136)
            (set! x_137 -137)
            (set! x_138 -138)
            (set! x_139 -139)
            (set! x_140 -140)
            (set! x_141 -141)
            (set! x_142 -142)
            (set! x_143 -143)
            (set! x_144 -144)
            (set! x_145 -145)
            (set! x_146 -146)
            (set! x_147 -147)
            (set! x_148 -148)
            (set! x_149 -149)
            (set! x_150 -150)
            (set! x_151 -151)
            (set! x_152 -152)
            (set! x_153 -153)
            (set! x_154 -154)
            (set! x_155 -155)
            (set! x_156 -156)
            (set! x_157 -157)
            (set! x_158 -158)
            (set! x_159 -159)
            (set! x_160 -160)
            (set! x_161 -161)
            (set! x_162 -162)
            (set! x_163 -163)
            (set! x_164 -164)
            (set! x_165 -165)
            (set! x_166 -166)
            (set! x_167 -167)
            (set! x_168 -168)
            (set! x_169 -169)
            (set! x_170 -170)
            (set! x_171 -171)
            (set! x_172 -172)
            (set! x_173 -173)
            (set! x_174 -174)
            (set! x_175 -175)
            (set! x_176 -176)
            (set! x_177 -177)
            (set! x_178 -178)
            (set! x_179 -179)
            (set! x_180 -180)
            (set! x_181 -181)
            (set! x_182 -182)
            (set! x_183 -183)
            (set! x_184 -184)
            (set! x_185 -185)
            (set! x_186 -186)
            (set! x_187 -187)
            (set! x_188 -188)
            (set! x_189 -189)
            (set! x_190 -190)
            (set! x_191 -191)
            (set! x_192 -192)
            (set! x_193 -193)
            (set! x_194 -194)
            (set! x_195 -195)
            (set! x_196 -196)
            (set! x_197 -197)
            (set! x_198 -198)
            (set! x_199 -199)
            (set! x_200 -200)
            (set! x_201 -201)
            (set! x_202 -202)
            (set! x_203 -203)
            (set! x_204 -204)
            (set! x_205 -205)
            (set! x_206 -206)
            (set! x_207 -207)
            (set! x_208 -208)
            (set! x_209 -209)
            (set! x_210 -210)
            (set! x_211 -211)
            (set! x_212 -212)
            (set! x_213 -213)
            (set! x_214 -214)
            (set! x_215 -215)
            (set! x_216 -216)
            (set! x_217 -217)
            (set! x_218 -218)
            (set! x_219 -219)
            (set! x_220 -220)
            (set! x_221 -221)
            (set! x_222 -222)
            (set! x_223 -223)
            (set! x_224 -224)
            (set! x_225 -225)
            (set! x_226 -226)
            (set! x_227 -227)
            (set! x_228 -228)
            (set! x_229 -229)
            (set! x_230 -230)
            (set! x_231 -231)
            (set! x_232 -232)
            (set! x_233 -233)
            (set! x_234 -234)
            (set! x_235 -235)
            (set! x_236 -236)
            (set! x_237 -237)
            (set! x_238 -238)
            (set! x_239 -239)
            (set! x_240 -240)
            (set! x_241 -241)
            (set! x_242 -242)
            (set! x_243 -243)
            (set! x_244 -244)
            (set! x_245 -245)
            (set! x_246 -246)
            (set! x_247 -247)
            (set! x_248 -248)
            (set! x_249 -249)
            (set! x_250 -250)
            (set! x_251 -251)
            (set! x_252 -252)
            (set! x_253 -253)
            (set! x_254 -254)
            (set! x_255 -255)
            (set! x_256 -256)
            (set! x_257 -257)
            (set! x_258 -258)
            (set! x_259 -259)
            (set! x_260 -260)
            (set! x_261 -261)
            (set! x_262 -262)
            (set! x_263 -263)
            (set! x_264 -264)
            (set! x_265 -265)
            (set! x_266 -266)
            (set! x_267 -267)
            (set! x_268 -268)
            (set! x_269 -269)
            (set! x_270 -270)
            (set! x_271 -271)
            (set! x_272 -272)
            (set! x_273 -273)
            (set! x_274 -274)
            (set! x_275 -275)
            (set! x_276 -276)
            (set! x_277 -277)
            (set! x_278 -278)
            (set! x_279 -279)
            (set! x_280 -280)
            (set! x_281 -281)
            (set! x_282 -282)
            (set! x_283 -283)
            (set! x_284 -284)
            (set! x_285 -285)
            (set! x_286 -286)
            (set! x_287 -287)
            (set! x_288 -288)
            (set! x_289 -289)
            (set! x_290 -290)
            (set! x_291 -291)
            (set! x_292 -292)
            (set! x_293 -293)
            (set! x_294 -294)
            (set! x_295 -295)
            (set! x_296 -296)
            (set! x_297 -297)
            (set! x_298 -298)
            (set! x_299 -299)
            (set! x_300 -300)
            (set! x_301 -301)
            (set! x_302 -302)
            (set! x_303 -303)
            (set! x_304 -304)
            (set! x_305 -305)
            (set! x_306 -306)
            (set! x_307 -307)
            (set! x_308 -308)
            (set! x_309 -309)
            (set! x_310 -310)
            (set! x_311 -311)
            (set! x_312 -312)
            (set! x_313 -313)
            (set! x_314 -314)
            (set! x_315 -315)
            (set! x_316 -316)
            (set! x_317 -317)
            (set! x_318 -318)
            (set! x_319 -319)
            (set! x_320 -320)
            (set! x_321 -321)
            (set! x_322 -322)
            (set! x_323 -323)
            (set! x_324 -324)
            (set! x_325 -325)
            (set! x_326 -326)
            (set! x_327 -327)
            (set! x_328 -328)
            (set! x_329 -329)
            (set! x_330 -330)
            (set! x_331 -331)
            (set! x_332 -332)
            (set! x_333 -333)
            (set! x_334 -334)
            (set! x_335 -335)
            (set! x_336 -336)
            (set! x_337 -337)
            (set! x_338 -338)
            (set! x_339 -339)
            (set! x_340 -340)
            (set! x_341 -341)
            (set! x_342 -342)
            (set! x_343 -343)
            (set! x_344 -344)
            (set! x_345 -345)
            (set! x_346 -346)
            (set! x_347 -347)
            (set! x_348 -348)
            (set! x_349 -349)
            (set! x_350 -350)
            (set! x_351 -351)
            (set! x_352 -352)
            (set! x_353 -353)
            (set! x_354 -354)
            (set! x_355 -355)
            (set! x_356 -356)
            (set! x_357 -357)
            (set! x_358 -358)
            (set! x_359 -359)
            (set! x_360 -360)
            (set! x_361 -361)
            (set! x_362 -362)
            (set! x_363 -363)
            (set! x_364 -364)
            (set! x_365 -365)
            (set! x_366 -366)
            (set! x_367 -367)
            (set! x_368 -368)
            (set! x_369 -369)
            (set! x_370 -370)
            (set! x_371 -371)
            (set! x_372 -372)
            (set! x_373 -373)
            (set! x_374 -374)
            (set! x_375 -375)
            (set! x_376 -376)
            (set! x_377 -377)
            (set! x_378 -378)
            (set! x_379 -379)
            (set! x_380 -380)
            (set! x_381 -381)
            (set! x_382 -382)
            (set! x_383 -383)
            (set! x_384 -384)
            (set! x_385 -385)
            (set! x_386 -386)
            (set! x_387 -387)
            (set! x_388 -388)
            (set! x_389 -389)
            (set! x_390 -390)
            (set! x_391 -391)
            (set! x_392 -392)
            (set! x_393 -393)
            (set! x_394 -394)
            (set! x_395 -395)
            (set! x_396 -396)
            (set! x_397 -397)
            (set! x_398 -398)
            (set! x_399 -399)

            x_0
            x_1
            x_2
            x_3
            x_4
            x_5
            x_6
            x_7
            x_8
            x_9
            x_10
            x_11
            x_12
            x_13
            x_14
            x_15
            x_16
            x_17
            x_18
            x_19
            x_20
            x_21
            x_22
            x_23
            x_24
            x_25
            x_26
            x_27
            x_28
            x_29
            x_30
            x_31
            x_32
            x_33
            x_34
            x_35
            x_36
            x_37
            x_38
            x_39
            x_40
            x_41
            x_42
            x_43
            x_44
            x_45
            x_46
            x_47
            x_48
            x_49
            x_50
            x_51
            x_52
            x_53
            x_54
            x_55
            x_56
            x_57
            x_58
            x_59
            x_60
            x_61
            x_62
            x_63
            x_64
            x_65
            x_66
            x_67
            x_68
            x_69
            x_70
            x_71
            x_72
            x_73
            x_74
            x_75
            x_76
            x_77
            x_78
            x_79
            x_80
            x_81
            x_82
            x_83
            x_84
            x_85
            x_86
            x_87
            x_88
            x_89
            x_90
            x_91
            x_92
            x_93
            x_94
            x_95
            x_96
            x_97
            x_98
            x_99
            x_100
            x_101
            x_102
            x_103
            x_104
            x_105
            x_106
            x_107
            x_108
            x_109
            x_110
            x_111
            x_112
            x_113
            x_114
            x_115
            x_116
            x_117
            x_118
            x_119
            x_120
            x_121
            x_122
            x_123
            x_124
            x_125
            x_126
            x_127
            x_128
            x_129
            x_130
            x_131
            x_132
            x_133
            x_134
            x_135
            x_136
            x_137
            x_138
            x_139
            x_140
            x_141
            x_142
            x_143
            x_144
            x_145
            x_146
            x_147
            x_148
            x_149
            x_150
            x_151
            x_152
            x_153
            x_154
            x_155
            x_156
            x_157
            x_158
            x_159
            x_160
            x_161
            x_162
            x_163
            x_164
            x_165
            x_166
            x_167
            x_168
            x_169
            x_170
            x_171
            x_172
            x_173
            x_174
            x_175
            x_176
            x_177
            x_178
            x_179
            x_180
            x_181
            x_182
            x_183
            x_184
            x_185
            x_186
            x_187
            x_188
            x_189
            x_190
            x_191
            x_192
            x_193
            x_194
            x_195
            x_196
            x_197
            x_198
            x_199
            x_200
            x_201
            x_202
            x_203
            x_204
            x_205
            x_206
            x_207
            x_208
            x_209
            x_210
            x_211
            x_212
            x_213
            x_214
            x_215
            x_216
            x_217
            x_218
            x_219
            x_220
            x_221
            x_222
            x_223
            x_224
            x_225
            x_226
            x_227
            x_228
            x_229
            x_230
            x_231
            x_232
            x_233
            x_234
            x_235
            x_236
            x_237
            x_238
            x_239
            x_240
            x_241
            x_242
            x_243
            x_244
            x_245
            x_246
            x_247
            x_248
            x_249
            x_250
            x_251
            x_252
            x_253
            x_254
            x_255
            x_256
            x_257
            x_258
            x_259
            x_260
            x_261
            x_262
            x_263
            x_264
            x_265
            x_266
            x_267
            x_268
            x_269
            x_270
            x_271
            x_272
            x_273
            x_274
            x_275
            x_276
            x_277
            x_278
            x_279
            x_280
            x_281
            x_282
            x_283
            x_284
            x_285
            x_286
            x_287
            x_288
            x_289
            x_290
            x_291
            x_292
            x_293
            x_294
            x_295
            x_296
            x_297
            x_298
            x_299
            x_300
            x_301
            x_302
            x_303
            x_304
            x_305
            x_306
            x_307
            x_308
            x_309
            x_310
            x_311
            x_312
            x_313
            x_314
            x_315
            x_316
            x_317
            x_318
            x_319
            x_320
            x_321
            x_322
            x_323
            x_324
            x_325
            x_326
            x_327
            x_328
            x_329
            x_330
            x_331
            x_332
            x_333
            x_334
            x_335
            x_336
            x_337
            x_338
            x_339
            x_340
            x_341
            x_342
            x_343
            x_344
            x_345
            x_346
            x_347
            x_348
            x_349
            x_350
            x_351
            x_352
            x_353
            x_354
            x_355
            x_356
            x_357
            x_358
            x_359
            x_360
            x_361
            x_362
            x_363
            x_364
            x_365
            x_366
            x_367
            x_368
            x_369
            x_370
            x_371
            x_372
            x_373
            x_374
            x_375
            x_376
            x_377
            x_378
            x_379
            x_380
            x_381
            x_382
            x_383
            x_384
            x_385
            x_386
            x_387
            x_388
            x_389
            x_390
            x_391
            x_392
            x_393
            x_394
            x_395
            x_396
            x_397
            x_398
            x_399

    )V0G0N"; 
    string test_48 = R"V0G0N(   
               ((lambda (x y z) x) 1 5 '3)              ; creating a lambda simple closure and applying it, return 1 - checks that args were pushed on the stack in the correct order  
    )V0G0N";
    string test_49 = R"V0G0N(   
                ((lambda (x y z) z) 1 5 '3)              ; creating a lambda simple closure and applying it, return 3 - checks that args were pushed on the stack in the correct order 
    )V0G0N";
    string test_50 = R"V0G0N(   
           33455 " \n \t \f                           \r \n \f hello                    "   58687942  "k dfldsfdsk l4lgb gflfdgl" 44654 
           " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " #t
           " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " 5
           " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " 'dfdfdsfhgfdhd4gfdggfgdf
           '#(5 6 74 66 33 566 33 )
    )V0G0N";
    string test_51 = R"V0G0N(   
              33455   " \n \t \f                           \r \n \f hello                    "   58687942 "k dfldsfdsk l4lgb gflfdgl" 44654 
            " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " #t
           " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " 5
            " \n \t \f                           \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " 'dfdfdsfhgfdhd4gfdggfgdf
           '#(5 6 74 66 33 566 33 )
           'fgfdgf 
           '(5 6 7 8 9)
           " \n \t \f       sdfdsfds345345      dfsdfds              \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " '(5 6 7 8 9)
             " \n \t \f       sdfdsfds345345      dfsdfds              \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " '(5 'hgeed 6 7 8 9)
            " \n \t \f       sdfdsfds345345      dfsdfds              \r \n \f hello                \n \t \r \n dfdsfds 445 fgfdgfd    " 4543564363
    )V0G0N";
    string test_52 = R"V0G0N(   
                 ((lambda (a b c) ((lambda (e f) ((lambda (x y z) x) e f a)) a b)) 1 2 3)  ; tail position application - check the the env expansion works properly, should return 1
    )V0G0N";
    string test_53 = R"V0G0N(   
                 ((lambda (a b c) ((lambda (e f) ((lambda (x y z) y) e f a)) a b)) 1 2 3)  ; tail position application - check the the env expansion works properly, should return 2
    )V0G0N";
    string test_54 = R"V0G0N(   
                 ((lambda (a b c) ((lambda (e f) ((lambda (x y z) z) e f a)) a b)) 1 2 3)  ; tail position application - check the the env expansion works properly, should return 1
    )V0G0N";
    string test_55 = R"V0G0N(   
                (define foo (lambda (x) x))               ; the following 3 lines test for closure creation, binding the closure to its position in the free var table, using it in a later definition and then using that later definition 
    )V0G0N";
    string test_56 = R"V0G0N(   
                 (define foo (lambda (x) x))
    )V0G0N";
    string test_57 = /*R"V0G0N(   
                 ((lambda s 1))                            ; variadic without arguments - check that Nil is pushed by hand to the stack, and then wrapped in a list: (Nil, Nil)
    )V0G0N"*/"";
    string test_58 = /*R"V0G0N(   
                 ((lambda (a . d) d) 1 2 3 4 6 7 8 9 10)      ; packing the optional arguments to a list - should return (4 . (6 . (7 . (8 . ()))))
    )V0G0N"*/"";
    string test_59 = /*R"V0G0N(   
                 ((lambda s 1) 2 3 4)
    )V0G0N"*/"";
    string test_60 = R"V0G0N(   
                 ((lambda (x) (set! x 5)) 1)               ; set! expressions return void - should print a newline in the prompt
    )V0G0N";
    string test_61 = R"V0G0N(   
                ((((lambda (x)
                (lambda (y)
                  y))
              (lambda (p)
                (p (lambda (x y)
                (lambda (p)
                  (p y x))))))
              (lambda (z) (z #t #f)))
            (lambda (x y) x))
    )V0G0N";
    string test_62 = /*R"V0G0N(   
             (let ((x #f) (y #t))
            (let ((x #f))
              (let ((x #f) (z #f) (t #f))
                (let ((x #f) (t #f))
            y))))   
    )V0G0N*/
    R"V0G0N(   
             (let ((x #f) (y #t))
            (let ((z 1))
            y))     
    )V0G0N";
    string test_63 = R"V0G0N(   
              (((((lambda (x) ((x x) (x x)))
              (lambda (x)
                (lambda (y)
            (x (x y)))))
            (lambda (p)
              (p (lambda (x y)
              (lambda (p)
                (p y x))))))
            (lambda (z) (z #t #f)))
          (lambda (x y) x))  
    )V0G0N";
    string test_64 = R"V0G0N(   
                ((((lambda (x)
                (lambda (y)
                  (x y)))
              (lambda (p)
                (p (lambda (x y)
                (lambda (p)
                  (p y x))))))
              (lambda (z) (z #t #f)))
            (lambda (x y) x))
    )V0G0N";
    string test_65 = R"V0G0N(   
               (append '((1 2) (3 4)) '((5 6) (7 8)) '(((9 10) '(11 12)))) 
    )V0G0N";
    string test_66 = R"V0G0N(   
                (append '(1 2 3) '(4 5 6))                  ; (1 . (2 . (3 . (4 . (5 . (6 . ()))))))
    )V0G0N";
    string test_67 = R"V0G0N(   
                (append '(1 2) '(3 4) '(5 6))               ; (1 . (2 . (3 . (4 . (5 . (6 . ()))))))
    )V0G0N";
    string test_68 = R"V0G0N(   
                (append 'a)                                 ; a
    )V0G0N";
    string test_69 = R"V0G0N(   
                (append '(1 2 3) '() '(1 2 . 3))            ; (1 . (2 . (3 . (1 . (2 . 3)))))
    )V0G0N";
    string test_70 = R"V0G0N(   
                (define x '(1 2)) (define y '(3 4)) (define z (append x y)) (set-car! x '*) (set-car! y '$) z                                           ; (1 . (2 . ($ . (4 . ()))))
    )V0G0N"; 
    string test_71 = R"V0G0N(   
                (append '(1) 2)
    )V0G0N";
 /*   string test_72 = R"V0G0N(   
                (apply (lambda (x y z) (list x y z)) "hello" "world" '("!"))     ; ("hello" . ("world" . ("!" . ())))
    )V0G0N";
    string test_73 = R"V0G0N(   
                (apply (lambda x x) '())                    ; ()
    )V0G0N";
    string test_74 = R"V0G0N(   
                (apply (lambda x x) 1 '(2))                 ; (1 . (2 . ()))
    )V0G0N";
    string test_75 = R"V0G0N(   
                (apply (lambda x x) '(2))                   ; (2 . ())
    )V0G0N";
    string test_76 = R"V0G0N(   
                (apply (lambda x x) 1 '())                  ; (1 . ())
    )V0G0N";
    string test_77 = R"V0G0N(   
                (apply cons 1 '(2))                         ; (1 . 2)
    )V0G0N";
    string test_78 = R"V0G0N(   
                (define fact-tail (lambda (n acc) (if (= 1 n) acc (fact-tail (- n 1) (* n acc))))) (apply fact-tail 5 '(1))                    ; 120
    )V0G0N";
    string test_79 = R"V0G0N(   
                (define fact-tail (lambda (n acc) (if (= 1 n) acc (fact-tail (- n 1) (* n acc))))) (apply fact-tail '(5 1))                    ; 120
    )V0G0N";*/
    string test_80 = R"V0G0N(   
                (define tail_test (lambda (n1) ((lambda (n2 n3) (+ n1 n3)) 10 15))) (tail_test 1)                               ; 16
    )V0G0N";
    /*string test_81 = R"V0G0N(   
                (define tail_test (lambda (n1) ((lambda (n2 n3) (+ n1 n3)) 10 15))) (apply tail_test '(1))                      ; 16
    )V0G0N";
    string test_82 = R"V0G0N(   
                (define tail_test (lambda (n1) ((lambda (n2 n3) (+ n1 n3)) 10 15))) (apply tail_test '(2))
    )V0G0N"; */
    string test_83 = R"V0G0N(   
                (< 11)                                      ; #t
    )V0G0N";
    string test_84 = R"V0G0N(   
                (< 1 2)                                     ; #t
    )V0G0N";
    string test_85 = R"V0G0N(   
                (< -0.5 0.0002)                              ; #t
    )V0G0N";
    string test_86 = R"V0G0N(   
                (< 3 2)                                     ; #f
    )V0G0N";
    string test_87 = R"V0G0N(   
                (< -3 -2 -1 0 0.5 0.6666666 0.75)
    )V0G0N";
    string test_88 = R"V0G0N(   
                (= 1 2)                                     ; #f
    )V0G0N";
    string test_89 = R"V0G0N(   
                (= 3 3 3 3 -1)                              ; #f
    )V0G0N";
    string test_90 = R"V0G0N(   
                (= 5 5 5 5 5 5 5 5 5 5 5)                   ; #t
    )V0G0N";
    string test_91 = R"V0G0N(   
                (= 2 2.0)
    )V0G0N";
    string test_92 = R"V0G0N(   
               (> 11)                                      ; #t 
    )V0G0N";
    string test_93 = R"V0G0N(   
              (> 1 2)                                     ; #f  
    )V0G0N";
    string test_94 = R"V0G0N(   
              (> -0.5 0.001)                              ; #f  
    )V0G0N";
    string test_95 = R"V0G0N(   
               (> 3 2)                                     ; #t 
    )V0G0N";
    string test_96 = R"V0G0N(   
               (> -3 -2 -1 0 0.5 0.4 0.3) 
    )V0G0N";
    string test_97 = R"V0G0N(   
               (+)                                         ; 0 
    )V0G0N";
    string test_98 = R"V0G0N(   
               (+ 1 -1)                                    ; 0 
    )V0G0N";
    string test_99 = R"V0G0N(   
              (+ 3 -0.5)                                  ; 5/2  
    )V0G0N";
    string test_100 = R"V0G0N(   
              (+ 0.3 0.5 )  
    )V0G0N";
    string test_101 = R"V0G0N(   
              (+ -0.234 0.234)                                 ;  
    )V0G0N";
    string test_102 = R"V0G0N(   
               (+ 0.25 0.25 0.25 0.25)                         ; 1 
    )V0G0N";
    string test_103 = R"V0G0N(   
               (+ 0.5 1e-2 0.32 5.1)                         ;  
    )V0G0N";
    string test_104 = R"V0G0N(   
               (+ 0.5 -0.3333 0.25 -0.2) 
    )V0G0N";
    string test_105 = R"V0G0N(   
                (/ 4 2)                                     ; 2
    )V0G0N";
    string test_106 = R"V0G0N(   
                (/ 6 -2)                                    ; -3
    )V0G0N";
    string test_107 = R"V0G0N(   
                (/ 1)                                       ; 1
    )V0G0N";
    string test_108 = R"V0G0N(   
                (+ 0 3.23e-2 )
    )V0G0N";
    string test_109 = R"V0G0N(   
                (*)                                         ; 1
    )V0G0N";
    string test_110 = R"V0G0N(   
               (* 2)                                       ; 2 
    )V0G0N";
    string test_111 = R"V0G0N(   
               (* 5 0.5)                                   ;  
    )V0G0N";
    string test_112 = R"V0G0N(   
               (* -3 -3)                                   ; 9 
    )V0G0N";
    string test_113 = R"V0G0N(   
                (* -0.17 0.19)                                    
    )V0G0N";
    string test_114 = R"V0G0N(   
                (- 3)                                       ; -3
    )V0G0N";
    string test_115 = R"V0G0N(   
                (- 0.4)                                     ; 
    )V0G0N";
    string test_116 = R"V0G0N(   
              (- 1 -1)                                    ; 2 
    )V0G0N";
    string test_117 = R"V0G0N(   
              (- 3 -0.5)                                  ; 7/2  
    )V0G0N";
    string test_118 = R"V0G0N(   
              (- 0.3 0.5)                                 ; -1/6  
    )V0G0N";
    string test_119 = R"V0G0N(   
              (- 0.02342 0.02342)                                 ; 0  
    )V0G0N";
    string test_120 = R"V0G0N(   
               (- 0.25 0.25 0.25 0.25)                         ; -1/2 
    )V0G0N";
    string test_121 = R"V0G0N(   
                (- 0.5 0.3333 0.25 0.2)                         ; -17/60
    )V0G0N";
    string test_122 = R"V0G0N(   
                (- 0.5 -0.3 0.25 -0.2)
    )V0G0N";
    string test_123 = R"V0G0N(   
                (boolean? #t)                               ; #t
    )V0G0N";
    string test_124 = R"V0G0N(   
                (boolean? #f)                               ; #t
    )V0G0N";
    string test_125 = R"V0G0N(   
                (boolean? (lambda (x y z) x y z y x))       ; #f
    )V0G0N";
    string test_126 = R"V0G0N(   
                (boolean? (if #f #f #f))                    ; #t
    )V0G0N";
    string test_127 = R"V0G0N(   
                (boolean? (if #f #t))                       ; #f
    )V0G0N";
    string test_128 = R"V0G0N(   
                (boolean? (and 1 2))                        ; #f
    )V0G0N";
    string test_129 = R"V0G0N(   
                (boolean? (and #f #f))                      ; #t
    )V0G0N";
    string test_130 = R"V0G0N(   
                (boolean? (and))                            ; #t
    )V0G0N";
    string test_131 = R"V0G0N(   
                (boolean? 5)
    )V0G0N";
    string test_132 = R"V0G0N(   
                (car '(1 2 3))
    )V0G0N";
    string test_133 = R"V0G0N(   
                (cdr '(1 2 3))
    )V0G0N";
    string test_134 = R"V0G0N(   
                (char->integer #\A)                         ; 65
    )V0G0N";
    string test_135 = R"V0G0N(   
                (char->integer #\page)
    )V0G0N";
    string test_136 = R"V0G0N(   
                (char? #\5)                                 ; #t
    )V0G0N";
    string test_137 = R"V0G0N(   
                (char? #\newline)                           ; #t
    )V0G0N";
    string test_138 = R"V0G0N(   
                (char? -0.19)
    )V0G0N";
    string test_139 = R"V0G0N(   
                (cons #xabc #t)                             ; (2748 . #t)
    )V0G0N";
    string test_140 = R"V0G0N(   
                (cons 1 (cons -2 (cons 3 (cons #t '()))))
    )V0G0N";
    string test_141 = R"V0G0N(   
                (eq? (if #f #f) (if #f #f))                 ; #t
    )V0G0N";
    string test_142 = R"V0G0N(   
                (eq? '() '())                               ; #t
    )V0G0N";
    string test_143 = R"V0G0N(   
                (eq? #f #f)                                 ; #t
    )V0G0N";
    string test_144 = R"V0G0N(   
               (eq? #f #t)                                 ; #f
    )V0G0N";
    string test_145 = R"V0G0N(   
                (eq? #\a #\A)                               ; #f
    )V0G0N";
    string test_146 = R"V0G0N(   
                (eq? -1 2)                                  ; #f
    )V0G0N";
    string test_147 = R"V0G0N(   
                (eq? 0.4 2)                               ; #f
    )V0G0N";
    string test_148 = R"V0G0N(   
                (eq? #\newline #\newline)                   ; #t
    )V0G0N";
    string test_149 = R"V0G0N(   
                (eq? -1 -1)                                 ; #t
    )V0G0N";
    string test_150 = R"V0G0N(   
                                            ; #t
    )V0G0N";
    string test_151 = R"V0G0N(   
                                        ; #t (because of constants table)
    )V0G0N";
    string test_152 = R"V0G0N(   
                (eq? 'ab 'ab)                               ; #t
    )V0G0N";
   /* string test_153 = R"V0G0N( 
               
              (define x1 (lambda () '()))           
              (define x2 (lambda (y1) '(y1)))          
              (define x3 (lambda (y1 y2) '(y1 y2)))
              (define x4 (lambda (y1 y2 y3) '(y1 y2 y3))) 
              (define x5 (lambda (y1 y2 y3 y4) '(y1 y2 y3 y4))) 
              (define x6 (lambda (y1 y2 y3 y4 y5) '(y1 y2 y3 y4 y5))) 

              ;Checking applic is ok, poping stack correctly after execution, check rsp is restored correctly if seg fault 
              (x1)
              (x2 1)
              (x3 1 2)
              (x4 1 2 3)
              (x5 1 2 3 4)
              (x6 1 2 3 4 5)
    )V0G0N"; */
    string test_154 = R"V0G0N(   
                (eq? '(1 2) '(1))                           ; #f
    )V0G0N";
   /* string test_155 = R"V0G0N(   
              (define x1 (lambda y y))           
              (define x2 (lambda (y1 . y2) `(y1 ,@y2)))          
              (define x3 (lambda (y1 y2 . y3) `(y1 y2 ,@y3)))
              (define x4 (lambda (y1 y2 y3 . y4) `(y1 y2 y3 ,@y4))) 
              (define x5 (lambda (y1 y2 y3 y4 . y5) `(y1 y2 y3 y4 ,@y5))) 
              (define x6 (lambda (y1 y2 y3 y4 y5 . y6) `(y1 y2 y3 y4 y5 ,@y6))) 

              ;Checking applic is ok, poping stack correctly after execution, check rsp is restored correctly if seg fault 
              ; Checking lambda opt shift frame works correctly so that the applic will be able to restore rsp correctly 
              (x1)
              (x2 1 2 3 4 5 6 7 8 9 10)
              (x3 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
              (x4 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
              (x5 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40)
              (x6 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50)
    )V0G0N"; */
    string test_156 = R"V0G0N(   
                (eq? '#(vector) '#(list))
    )V0G0N";
    string test_157 = R"V0G0N(   
                (integer? -10000000)                        ; #t
    )V0G0N";
    string test_158 = R"V0G0N(   
                (integer? 3.14)                             ; #f
    )V0G0N";
    string test_159 = R"V0G0N(   
                (integer? cons)
    )V0G0N";
    string test_160 = R"V0G0N(   
               (integer->char 10)                          ; #\newline 
    )V0G0N";
    string test_161 = R"V0G0N(   
                (integer->char 60)
    )V0G0N";
    string test_162 = R"V0G0N(   
               (list 'list)                                
    )V0G0N";
    string test_163 = R"V0G0N(   
                (list -1 2 -3 4)                            ; (-1 . (2 . (-3 . (4 . ()))))
    )V0G0N";
    string test_164 = R"V0G0N(   
                (list #t #t #f #t)                          ; (#t . (#t . (#f . (#t . ()))))
    )V0G0N";
    string test_165 = R"V0G0N(   
                (list)
    )V0G0N";
    string test_166 = R"V0G0N(   
                (make-string 3)                             ; "\000;\000;\000;"
    )V0G0N";
    string test_167 = R"V0G0N(   
                (make-string 5 #\r)
    )V0G0N";
    string test_168 = R"V0G0N(   
                (make-vector 7)                             ; #(0 0 0 0 0 0 0)
    )V0G0N";
    string test_169 = R"V0G0N(   
                (make-vector 2 "scheme")
    )V0G0N";
    string test_170 = R"V0G0N(   
                (map (lambda (s) "batman") '("why" "so" "serious?"))
    )V0G0N";
    string test_171 = R"V0G0N(   
                (map (lambda (x) x) '(-1 -2 -0.6))          ; (-1 . (-2 . (-3/5 . ())))
    )V0G0N";
    string test_172 = R"V0G0N(   
                (map + '(1 2 0.333) '(-1 -2 -0.333))            ; (0 . (0 . (0 . ())))
    )V0G0N";
    string test_173 = R"V0G0N(   
                (map list '("a" "b" "c") '('a 'b 'c) '(1 2 3) '(0.5 0.333 0.25))
    )V0G0N";
    string test_174 = R"V0G0N(   
                (not #f)                                    ; #t
    )V0G0N";
    string test_175 = R"V0G0N(   
                (not #t)                                    ; #f
    )V0G0N";
   /* string test_176 = R"V0G0N(   
            (define x1 (lambda y y))           
       
            ;Checking applic is ok, poping stack correctly after execution, check rsp is restored correctly if seg fault 
            ; Checking lambda opt shift frame works correctly so that the applic will be able to restore rsp correctly 
            (x1)
            (x1 1 2 3 4 5 6 7 8 9 10)
            (x1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)
            (x1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)
            (x1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40)
            (x1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50)                                                ; #f
    )V0G0N"; */
    string test_177 = R"V0G0N(   
                (null? '())                                 ; #t
    )V0G0N";
    string test_178 = R"V0G0N(   
                (null? '(9 #\F))                            ; #f
    )V0G0N";
    string test_179 = R"V0G0N(   
                (null? null?)                               ; #f
    )V0G0N";
    string test_180 = R"V0G0N(   
                (number? -1)                                ; #t
    )V0G0N";
    string test_181 = R"V0G0N(   
                (number? -3.14)                             ; #t
    )V0G0N";
    string test_182 = R"V0G0N(   
                (number? #t)                                ; #f
    )V0G0N";
    string test_183 = R"V0G0N(   
                (number? "hello, world!")
    )V0G0N";
    string test_184 = R"V0G0N(   
                (pair? '(1 2))                              ; #t
    )V0G0N";
    string test_185 = R"V0G0N(   
                (pair? '())                                 ; excpetion - wrong number of arguments
    )V0G0N";
    string test_186 = R"V0G0N(   
                (pair? 5)
    )V0G0N";
    string test_187 = R"V0G0N(   
                (procedure? procedure?)                     ; #t
    )V0G0N";
    string test_188 = R"V0G0N(   
                (procedure? (lambda s (car s)))             ; #t
    )V0G0N";
    string test_189 = R"V0G0N(   
                (procedure? #t)
    )V0G0N";
    string test_190 = R"V0G0N(   
                (set-car! '(a b c) '(x y z))
    )V0G0N";
    string test_191 = R"V0G0N(   
               (set-car! '(1 2 3) (cdr '(1 2 3))) 
    )V0G0N";
    string test_192 = R"V0G0N(   
                (define l '(1 2 3)) (set-car! l '(4 5)) l (car l) (cdr l)
    )V0G0N";
    string test_193 = R"V0G0N(   
                (set-cdr! '(a b c) '(x y z))
    )V0G0N";
    string test_194 = R"V0G0N(   
               (set-cdr! '(1 2 3) (cdr '(1 2 3))) 
    )V0G0N";
    string test_195 = R"V0G0N(   
                (define l '(1 2 3)) (set-cdr! l '(4 5)) l (car l) (cdr l)
    )V0G0N";
    string test_196 = R"V0G0N(   
                (string-length "")                          ; 0
    )V0G0N";
    string test_197 = R"V0G0N(   
                (string-length "a")
    )V0G0N";
    string test_198 = R"V0G0N(   
                (string-ref "string" 1)
    )V0G0N";
    string test_199 = R"V0G0N(   
               (string-set! "string" 1 #\p) 
    )V0G0N";
    string test_200 = R"V0G0N(   
              (string? "string")                          ; #t  
    )V0G0N";
    string test_201 = R"V0G0N(   
                (string? 'string)                           ; #f
    )V0G0N";
    string test_202 = R"V0G0N(   
                (string? 2)
    )V0G0N";
    string test_203 = R"V0G0N(   
                (symbol? 'symbol)                           ; #t
    )V0G0N";
    string test_204 = R"V0G0N(   
                (symbol? "symbol")                          ; #f
    )V0G0N";
    string test_205 = R"V0G0N(   
                (symbol? 2)
    )V0G0N";
    string test_206 = R"V0G0N(   
               'sym 
    )V0G0N";
    string test_207 = R"V0G0N(   
                (vector 'vector 'vector)                      ; #(vector vector)
    )V0G0N";
    string test_208 = R"V0G0N(   
               (vector 'a 1 1e1 "uno" 'einz)               ; #(a 1 1 "uno" einz) 
    )V0G0N";
    string test_209 = R"V0G0N(   
                (vector)
    )V0G0N";
    string test_210 = R"V0G0N(   
                (vector-length '#())                        ; 0
    )V0G0N";
    string test_211 = R"V0G0N(   
                (vector-length '#(vector? vector-ref))
    )V0G0N";
    string test_212 = R"V0G0N(   
               (vector-ref '#(1 2 3) 0) 
    )V0G0N";
    string test_213 = R"V0G0N(   
               (vector-set! '#(4 5 6) 1 7) 
    )V0G0N";
    string test_214 = R"V0G0N(   
                (vector? "no")                              ; #f
    )V0G0N";
    string test_215 = R"V0G0N(   
               (vector? '#(1 b 3 d 5 f)) 
    )V0G0N";
    string test_216 = R"V0G0N(   
                (zero? 0)                                   ; #t
    )V0G0N";
    string test_217 = R"V0G0N(   
              (zero? 0e10)                                 ; #t  
    )V0G0N";
    string test_218 = R"V0G0N(   
              (zero? (- 5 (+ 1 2 2)))  
    )V0G0N";
  /*  string test_219 = R"V0G0N(   
              (define fact (lambda (n)
                (if (zero? n)
                1
                (* n (fact (- n 1))))))


        (let ((fact10  (fact 10)))
            `(fact 10 is: ,fact10))  
    )V0G0N";
    string test_220 = R"V0G0N(   
                (define fact (lambda (n)
                (if (zero? n)
                1
                (* n (fact (- n 1))))))


        (let ((lst  `(,(fact 10) ,(fact 7) ,(fact 6) ,(fact 20))))
            `(some facts are: ,@lst))
    )V0G0N";
    string test_221 = R"V0G0N(   
                ; Checking env working properly
                (define x (lambda (x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) 
                              (lambda (y1 y2 y3 y4 y5 y6 y7 y8 y9 y10) 
                                    (lambda (z1 z2 z3 z4 z5 z6 z7 z8 z9 z10) 
                                        (lambda (k1 k2 k3 k4 k5 k6 k7 k8 k9 k10) 
                                            (lambda (l1 l2 l3 l4 l5 l6 l7 l8 l9 l10) 
                                                 (lambda (h1 h2 h3 h4 h5 h6 h7 h8 h9 h10) 
                                                    `(,x1 ,x2 ,x3 ,x4 ,x5 ,x6 ,x7 ,x8 ,x9 ,x10
                                                      ,y1 ,y2 ,y3 ,y4 ,y5 ,y6 ,y7 ,y8 ,y9 ,y10
                                                      ,z1 ,z2 ,z3 ,z4 ,z5 ,z6 ,z7 ,z8 ,z9 ,z10
                                                      ,k1 ,k2 ,k3 ,k4 ,k5 ,k6 ,k7 ,k8 ,k9 ,k10
                                                      ,l1 ,l2 ,l3 ,l4 ,l5 ,l6 ,l7 ,l8 ,l9 ,l10
                                                      ,h1 ,h2 ,h3 ,h4 ,h5 ,h6 ,h7 ,h8 ,h9 ,h10
                                                  )
                                            )
                                
                                        ) 
                                
                                   ) 
                                
                             ) 
                          )   
                 )
)
                ((((((x 1 2 3 4 5 6 7 8 9 10) 11 12 13 14 15 16 17 18 19 20) 21 22 23 24 25 26 27 28 29 30) 31 32 33 34 35 36 37 38 39 40) 41 42 43 44 45 46 47 48 49 50) 51 52 53 54 55 56 57 58 59 60)
    )V0G0N";
    string test_222 = R"V0G0N(   
                    ; Checking env working properly
                  (define x (lambda (x1 x2 x3 x4 x5 x6 x7 x8 x9 . x10) 
                              (lambda (y1 y2 y3 y4 y5 y6 y7 y8 y9 . y10) 
                                    (lambda (z1 z2 z3 z4 z5 z6 z7 z8 z9 . z10) 
                                        (lambda (k1 k2 k3 k4 k5 k6 k7 k8 k9 . k10) 
                                            (lambda (l1 l2 l3 l4 l5 l6 l7 l8 l9 . l10) 
                                                 (lambda (h1 h2 h3 h4 h5 h6 h7 h8 h9 . h10) 
                                                    `(,x1 ,x2 ,x3 ,x4 ,x5 ,x6 ,x7 ,x8 ,x9 ,@x10 
                                                      ,y1 ,y2 ,y3 ,y4 ,y5 ,y6 ,y7 ,y8 ,y9 ,@y10
                                                      ,z1 ,z2 ,z3 ,z4 ,z5 ,z6 ,z7 ,z8 ,z9 ,@z10
                                                      ,k1 ,k2 ,k3 ,k4 ,k5 ,k6 ,k7 ,k8 ,k9 ,@k10
                                                      ,l1 ,l2 ,l3 ,l4 ,l5 ,l6 ,l7 ,l8 ,l9 ,@l10
                                                      ,h1 ,h2 ,h3 ,h4 ,h5 ,h6 ,h7 ,h8 ,h9 ,@h10
                                                  )
                                            )
                                
                                        ) 
                                
                                   ) 
                                
                             ) 
                          )   
                 )
)
                ((((((x 1 2 3 4 5 6 7 8 9 10) 11 12 13 14 15 16 17 18 19 20 -11) 21 22 23 24 25 26 27 28 29 30 -30 -31) 31 32 33 34 35 36 37 38 39 40 -40 -41 -42 -43) 41 42 43 44 45 46 47 48 49 50 -50 -51 -52 -53 -54 -55 -56) 51 52 53 54 55 56 57 58 59 60 -55 -66 -77 -88 -99 -100)     
    )V0G0N";
    string test_223 = R"V0G0N(   
                              ; Checking env working properly
                               (define x (lambda x10
                              (lambda y10
                                    (lambda z10 
                                        (lambda k10
                                            (lambda l10
                                                 (lambda h10
                                                    `(,@x10 
                                                      ,@y10
                                                      ,@z10
                                                      ,@k10
                                                      ,@l10
                                                      ,@h10)
                                                  )
                                            )
                                
                                        ) 
                                
                                   ) 
                                
                             ) 
                          )   
                 )

                ((((((x 1 2 3 4 5 6 7 8 9 10) 11 12 13 14 15 16 17 18 19 20 -11) 21 22 23 24 25 26 27 28 29 30 -30 -31) 31 32 33 34 35 36 37 38 39 40 -40 -41 -42 -43) 41 42 43 44 45 46 47 48 49 50 -50 -51 -52 -53 -54 -55 -56) 51 52 53 54 55 56 57 58 59 60 -55 -66 -77 -88 -99 -100)       
    )V0G0N";
    string test_224 = R"V0G0N(   
              (define x1 5)           
              (define x2 5)          
              (define x3 5)
              (define x4 5) 
              (define x5 5) 
              (define x6 5) 

              ; Checking applic tp with changed number of arguments
              (set! x1 (lambda () (x2 1)))           
              (set! x2 (lambda (y1) (x3 y1 2)))          
              (set! x3 (lambda (y1 y2) (x4 y1 y2 3)))
              (set! x4 (lambda (y1 y2 y3) (x5 y1 y2 y3 4))) 
              (set! x5 (lambda (y1 y2 y3 y4) (x6 y1 y2 y3 y4 5))) 
              (set! x6 (lambda (y1 y2 y3 y4 y5) `(,y1 ,y2 ,y3 ,y4 ,y5))) 

               (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
                 
    )V0G0N";
    string test_225 = R"V0G0N(   
              (define x1 5)           
              (define x2 5)          
              (define x3 5)
              (define x4 5) 
              (define x5 5) 
              (define x6 5) 

              ; Checking applic tp with changed number of arguments
              (set! x1 (lambda () (x2 1)))           
              (set! x2 (lambda (y1) (x3 y1 2)))          
              (set! x3 (lambda (y1 . y2) (x4 y1 y2 3 4 5 6 7 8)))
              (set! x4 (lambda (y1 y2 . y3) (x5 y1 y2 y3 4 11 12 13 14 15))) 
              (set! x5 (lambda (y1 y2 y3 . y4) (x6 y1 y2 y3 y4 5 16 17 18 19 20))) 
              (set! x6 (lambda (y1 y2 y3 y4 . y5) `(,y1 ,@y2 ,@y3 ,@y4 ,@y5))) 

              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
    )V0G0N";
    string test_226 = R"V0G0N(   
           (define x1 5)           
              (define x2 5)          
              (define x3 5)
              (define x4 5) 
              (define x5 5) 
              (define x6 5) 

              ; Checking applic tp with changed number of arguments
              (set! x1 (lambda y0 (x2)))           
              (set! x2 (lambda y1 (x3 y1 2)))          
              (set! x3 (lambda y2 (x4 y2 3 4 5 6 7 8)))
              (set! x4 (lambda y3 (x5 y3 4 11 12 13 14 15 3 0 4 32 4 56 865 3 566 43 56674566 ))) 
              (set! x5 (lambda y4 (x6 y4 5))) 
              (set! x6 (lambda y5 `(,@y5))) 

              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)
              (x1)    
              (x1)
              (x1)      
    )V0G0N";
    string test_227 = R"V0G0N(   
        (define last-pair
        (letrec ((loop
        (lambda (s r)
        (if (pair? r)
        (loop r (cdr r))
        s))))
        (lambda (s)
        (loop s (cdr s)))))   

        (define foo
        (lambda ()
        (let ((s (list 'he 'said:)))
        (set-cdr! (last-pair s)
        (list 'ha 'ha))
        s)))
        (define goo
        (lambda ()
        (let ((s '(he said:)))
        (set-cdr! (last-pair s)
        (list 'ha 'ha))
        s)))         

        (foo)
        (foo)
        (foo)
        (foo)
        (foo)
        (foo)
        (foo)
        (foo)

        (goo)
        (goo)
        (goo)
        (goo)
        (goo)
        (goo)
        (goo)
        (goo)
        (goo)
    )V0G0N";
    string test_228 = R"V0G0N(   
                (define foo 6)
                (define n 0)

                (set! foo (lambda (x  h)
                                (if (null? h)
                                    (begin (set! n (+ n 1))
                                     n)
                                (cons x (foo (car h) (cdr h))) 
                                )
                            )
                 )

        (foo "a" '("b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"))
    )V0G0N";
    string test_229 = R"V0G0N(   
                (define foo 6)
                (define n 0)

                (set! foo (lambda (x  . h)
                                (if (null? h)
                                    (begin (set! n (+ n 1))
                                     n)
                                (begin (set! n (+ n 1)) (cons x (apply foo (car h) (cdr h)))) 
                                )
                            )
                 )

        (foo "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")    
    )V0G0N";
    string test_230 = R"V0G0N(   
          (define foo 6)
                (define n 0)

                (set! foo (lambda (x  . h)
                                (if (null? h)
                                    (begin (set! n (+ n 1))
                                     n)
                                (begin (set! n (+ n 1)) (set-car! h n) (cons x (apply foo (car h) (cdr h)))) 
                                )
                            )
                 )

        (foo "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")        
    )V0G0N";
    string test_231 = R"V0G0N(   
            (define foo 6)
                (define n 0)

                (set! foo (lambda (x  . h)
                                (if (null? h)
                                    (begin (set! n (+ n 1))
                                     n)
                                (begin (set! n (+ n 1)) (set-cdr! h '()) (cons x (apply foo (car h) (cdr h)))) 
                                )
                            )
                 )

        (foo "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z")      
    )V0G0N";
    string test_232 = R"V0G0N(   
           (or 4 5 3 4 5 9 8372 8384 822 3 3432 23432 34325 09 79 7332 344 998 221 4543 'dfdsf '53443 'ghgh)     
    )V0G0N";
    string test_233 = R"V0G0N(  
            (define x (lambda x x)) 
            (or (x 5) (x 5 3 4 5) (x 5 5 5 6 1) (x 5 1 1 1 ) (x 5 5 4 3) (x 5 34 6) (x 5 4 5 6) (x 5 1 5 5 ) (x 5 56 64) (x) (x 5 3 4) (x 5 5 6 7 ) (x 5) (x 5.6))    
    )V0G0N";
    string test_234 = R"V0G0N(  
            (define (member x list)
                (if (null? list) #f                                
                    (if (equal? x (car list)) #t                   
                        (member x (cdr list))))) 

            (define set-union
            (lambda (s1 s2)
            (cond ((null? s1) s2)
            ((member (car s1) s2)
            (set-union (cdr s1) s2))
            (else (cons (car s1)
            (set-union (cdr s1) s2))))))

            (set-union (list 1 2 3 4) (list 6 4 8 2))
    )V0G0N";
    string test_235 = R"V0G0N(   
            (define deep-member
            (lambda (a s)
            (or (equal? a s)
            (and (pair? s)
            (or (deep-member a (car s))
            (deep-member a (cdr s)))))))  

            (deep-member 'foo '(a b (c (d e foo g)) h)) 
            (deep-member 'foo '(a b (c (d e bar g)) h)) 
    )V0G0N";
    string test_236 = R"V0G0N(   
            (define filter-numbers
                (lambda (lis)
                (cond ((null? lis) lis)
                ((number? (car lis))
                (cons (car lis) (filter-numbers (cdr lis))))
                (else (filter-numbers (cdr lis))))))     

                (filter-numbers '(1 one 2 two foo zero 22.7 0))   
    )V0G0N";
    string test_237 = "\"This is a string\"";
    string test_238 = "\"This is a string with  \"";
    string test_239 = R"V0G0N(
                (define *free-variable* 'lexical-scope)
                (define return-free-variable
                (lambda () *free-variable*))
                (define get-scope
                (lambda ()
                (let ((*free-variable* 'dynamic-scope))
                (return-free-variable))))

                (get-scope)
    )V0G0N"; */
    string test_240 = R"V0G0N( 
        (equal? "  \n \t \r \f  " "  \n \t \r \f  ")
    
    )V0G0N";
    string test_241 = "\"This is a string with 3333333 \"";
    string test_242 = "\"This is a string with 23432422 \""; 
    string test_243 = R"V0G0N(
      (equal? "  \n \t \r \f  " "  \n \t \r \f  This is a string")
    
    )V0G0N";
    string test_244 = R"V0G0N( 
          (letrec ((countdown (lambda (i)
                      (if (= i 0) 'liftoff
                          (begin
                            'finish
                            (countdown (- i 1)))))))
            (countdown 100))
    )V0G0N";
    string test_245 = R"V0G0N( 
        (let* ([x 1]
         [y (+ x 1)])
    (list y x))
    )V0G0N";
    string test_246 = R"V0G0N( 
            (letrec ([is-even? (lambda (n)
                       (or (zero? n)
                           (is-odd? (- n 1))))]
           [is-odd? (lambda (n)
                      (and (not (zero? n))
                           (is-even? (- n 1))))])
    (is-odd? 11))
    )V0G0N";
    string test_247 = R"V0G0N( 
            (letrec ((countdown (lambda (i)
                      (if (= i 0) 'liftoff
                          (begin
                            'finish
                            (countdown (- i 1)))))))
            (countdown 10))
    )V0G0N";
    string test_248 = R"V0G0N( 
            (letrec ((countdown (lambda (i)
                      (if (= i 0) 'liftoff
                          (begin
                            'finish
                            (countdown (- i 1)))))))
            (countdown 400))
    )V0G0N";
    string test_249 = R"V0G0N( 
        (equal? '(1 2 3) '(10 20 30 " \n \t \r \f  "))
    )V0G0N";
    string test_250 = R"V0G0N(   
            ;;
            ;; Function: celsius->fahrenheit
            ;; -----------------------------
            ;; Simple conversion function to bring a Celsius
            ;; degree amount into Fahrenheit.
            ;;
            (define (celsius->fahrenheit celsius)
            (+ (* 1.8 celsius) 32))    

            (celsius->fahrenheit 34)
            (celsius->fahrenheit 22)
            (celsius->fahrenheit 11)
            (celsius->fahrenheit 1000)
    )V0G0N";
    string test_251 = R"V0G0N(   

            ;;
            ;; Function: factorial
            ;; -------------------
            ;; Traditional recursive formulation of the most obvious recursive
            ;; function ever. Note the use of the built-in zero?
            ;; to check to see if we have a base case.
            ;;
            ;; What's more impressive about this function is that it demonstrates
            ;; how Scheme can represent arbitrarily large integers. Type
            ;; in (factorial 1000) and see what you get. Try doing *that* with
            ;; C or Java.
            ;;

            (define (factorial n)
                (if (zero? n) 1
                (* n (factorial (- n 1)))))  

            (factorial 0)
            (factorial 1)
            (factorial 2)
            (factorial 3)
            (factorial 4)
            (factorial 5)
            (factorial 6)
            (factorial 7)
            (factorial 8)
            (factorial 9)
            (factorial 10)
            (factorial 11)
            (factorial 12)
            (factorial 13)
            (factorial 14)
            (factorial 15)
            (factorial 16)
            (factorial 17)
            (factorial 18)
            (factorial 19)
            (factorial 20)
    )V0G0N";
    string test_252 = R"V0G0N(   

            ;;
            ;; Function: fibonacci
            ;; -------------------
            ;; Traditional recursive implementation of
            ;; the fibonacci function. This particular
            ;; implementation is pretty inefficient, since
            ;; it makes an exponential number of recursive
            ;; calls.
            ;;
            (define (fibonacci n)
            (if (< n 2) n
            (+ (fibonacci (- n 1))
            (fibonacci (- n 2)))))    

            (fibonacci 0)
            (fibonacci 1)
            (fibonacci 2)
            (fibonacci 3)
            (fibonacci 4)
            (fibonacci 5)
            (fibonacci 6)
            (fibonacci 7)
            (fibonacci 8)
            (fibonacci 9)
            (fibonacci 10)
            (fibonacci 11)
            (fibonacci 12)
            (fibonacci 13)
            (fibonacci 14)
            (fibonacci 15)
            (fibonacci 16)
            (fibonacci 17)
            (fibonacci 18)
            (fibonacci 19)
    )V0G0N";
    string test_253 = R"V0G0N(   
            ;;
            ;; Function: fast-fibonacci
            ;; ------------------------
            ;; Relies on the services of a helper function to
            ;; generate the nth fibonacci number much more quickly. The
            ;; key observation here: the nth number is the Fibonacci
            ;; sequence starting out 0, 1, 1, 2, 3, 5, 8 is the (n-1)th
            ;; number in the Fibonacci-like sequence starting out with
            ;; 1, 1, 2, 3, 5, 8. The recursion basically slides down
            ;; the sequence n or so times in order to compute the answer.
            ;; As a result, the recursion is linear instead of binary, and it
            ;; runs as quickly as factorial does.
            ;;
            (define (fast-fibonacci n)
            (fast-fibonacci-helper n 0 1))

            (define (fast-fibonacci-helper n base-0 base-1)
            (cond ((zero? n) base-0)
            ((zero? (- n 1)) base-1)
            (else (fast-fibonacci-helper (- n 1) base-1 (+ base-0 base-1)))))  

            (fast-fibonacci 0)
            (fast-fibonacci 1)
            (fast-fibonacci 2)
            (fast-fibonacci 3)
            (fast-fibonacci 4)
            (fast-fibonacci 5)
            (fast-fibonacci 6)
            (fast-fibonacci 7)
            (fast-fibonacci 8)
            (fast-fibonacci 9)
            (fast-fibonacci 10)
            (fast-fibonacci 11)
            (fast-fibonacci 12)
            (fast-fibonacci 13)
            (fast-fibonacci 14)
            (fast-fibonacci 15)
            (fast-fibonacci 16)
            (fast-fibonacci 17)
            (fast-fibonacci 18)
            (fast-fibonacci 19)  
    )V0G0N";
    string test_254 = R"V0G0N(   
            ;;
            ; Function: sum
            ; -------------
            ; Computes the sum of all of the numbers in the specified
            ; number list. If the list is empty, then the sum is 0.
            ; Otherwise, the sum is equal to the value of the car plus
            ; the sum of whatever the cdr holds.
            ;;
            (define (sum ls)
            (if (null? ls) 0
            (+ (car ls) (sum (cdr ls)))))  

            (sum '())
            (sum '(1))
            (sum '(1 2))
            (sum '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40))

    )V0G0N";
    string test_255 = R"V0G0N(   
            ;;
            ;; Function: triple-everything
            ;; ---------------------------
            ;; Takes a list of integers (identified by sequence)
            ;; and generates a copy of the list, except that
            ;; every integer in the new list has been tripled.
            ;;
            (define (triple-everything numbers)
            (if (null? numbers) '()
            (cons (* 3 (car numbers)) (triple-everything (cdr numbers)))))    

            (triple-everything '())
            (triple-everything '(1))
            (triple-everything '(1 2))
            (triple-everything '(1 2 3 4))
            (triple-everything '(1 2 3 4 5 6))
            (triple-everything '(1 2 3 4 5 6 7 8 9 10))
            (triple-everything '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40))

    )V0G0N";
    string test_256 = R"V0G0N(   
           ;;
            ;; Function: flatten
            ;; -----------------
            ;; Takes an arbitrary list and generates a another list where all atoms of the
            ;; original are laid down in order as top level elements.
            ;;
            ;; In order for the entire list to be flattened, the cdr of the
            ;; list needs to be flattened. If the car of the entire list is a primitive
            ;; (number, string, character, whatever), then all we need to do is
            ;; cons that primitive onto the front of the recursively flattened cdr.
            ;; If the car is itself a list, then it also needs to be flattened.
            ;; The flattened cdr then gets appended to the flattened car.
            ;;
            (define (flatten sequence)
                (cond ((null? sequence) '())
                ((list? (car sequence)) (append (flatten (car sequence))
                (flatten (cdr sequence))))
                (else (cons (car sequence) (flatten (cdr sequence)))))) 

            (flatten '(1 (2) 3))   
            (flatten '((1) (2 3 4) (5 6)))
            (flatten '(a (b (c d (e) f (g h))) (i j)))
            (flatten '("nothing" "to" "flatten"))
    )V0G0N";
    string test_257 = R"V0G0N(   
            ;;
            ;; Function: partition
            ;; -------------------
            ;; Takes a pivot and a list and produces a pair two lists.
            ;; The first of the two lists contains all of those element less than the
            ;; pivot, and the second contains everything else. Notice that
            ;; the first list pair every produced is (() ()), and as the
            ;; recursion unwinds exactly one of the two lists gets a new element
            ;; cons'ed to the front of it.
            ;;
            (define cadr (lambda (pair) (car (cdr pair))))
            (define (partition pivot num-list)
            (if (null? num-list) '(() ())
            (let ((split-of-rest (partition pivot (cdr num-list))))
            (if (< (car num-list) pivot)
            (list (cons (car num-list) (car split-of-rest))
            (cadr split-of-rest))
            (list (car split-of-rest) (cons (car num-list)
            (car (cdr split-of-rest))))))))    

            (partition 5 '(6 4 3 7 8 2 1 9 11))
            (partition 2 '(6 4 3 7 8 2 1 9 11))
            (partition 8 '(6 4 3 7 8 2 1 9 11))
            (partition 15 '(6 4 3 7 8 2 1 9 11 66 33 44 55 10 2 4 5.5 3.3 7 232432 24234)) 
    )V0G0N";
    string test_258 = "\"This is a string with 34345 43543 3.3 5.5 9 '(4 5) #()\"";
    string test_259 = R"V0G0N(   
             ((lambda (x y z)
                (lambda () (lambda () x))
                (set! x 400)
    ((lambda (z x y)
                    (lambda (y z x)
                    (set! x x)
                    (begin "  \n \t \r \f  This is a string" x x x)
                    )
                    (lambda () (set! x x))
                    x
                )x y z)
                ) 10 20 30)
    )V0G0N";
    string test_260 = R"V0G0N(   
           (begin
            ((lambda (x)
            x
                            ((lambda ()
                                ((lambda ()
                                '#(5 6 7 8)
                                55
                                "\n \r \f this is \n \r \f "
                                (set! x (set! x 4))
                                ))
                                ((lambda ()
                                (set! x 5)
                                ))
                            ))
                            ((lambda ()
                                (set! x 400)
                            
                            ))
            x
                            ) 100))    
    )V0G0N";
    string test_261 = R"V0G0N(   
        (define foo (lambda (x t y) "\n \r \f this is \n \r \f " 55 '#(5 6 7 8)
                                t))
        (apply foo '(1 2 3))
    )V0G0N";
    string test_262 = R"V0G0N(   
        (define foo (lambda (x t y r) t))
        (apply foo 4 '(1 2 3))       
    )V0G0N";
    string test_263 = R"V0G0N(   
        (define foo (lambda t t))
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3))      
    )V0G0N";
    string test_264 = R"V0G0N(   
        (define foo (lambda t t))
        (apply foo '())      
    )V0G0N";
    string test_265 = R"V0G0N(   
        (define foo (lambda t t))
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3))    
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3))    
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
        (apply foo 4 5 6 3 2 43 56 23 533 '(3 4) '(1 2 3)) 
    )V0G0N";
    string test_266 = R"V0G0N(   
           (if (+ 3 3) (* 2 2))     
    )V0G0N";
    string test_267 = R"V0G0N(   
             (if (equal? (+ 3 3) 6) (* 5 5) 0)    
    )V0G0N";
    string test_268 = R"V0G0N(   
            (if (equal? (+ 4 3) 6) (* 5 5) 0)     
    )V0G0N";
    string test_269 = R"V0G0N(   
            (and (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3)
            (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) (equal? 3 3) 'yes)    
    )V0G0N";
    string test_270 = R"V0G0N(  
            (define x 5) 
            (and (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) 
            (equal? x 5) (equal? x 5) (equal? x 5) (equal? x 5) (set! x 20) (equal? x 5) 'no)     
    )V0G0N";
    string test_271 = R"V0G0N(   
           (and)     
    )V0G0N";
    string test_272 = R"V0G0N(   
          (and 5)      
    )V0G0N";
    string test_273 = R"V0G0N(   
            (define (revall L)
                (if (null? L)
                L
                (let ((E (if (list? (car L))
                (revall (car L))
                (car L) )))
                (append (revall (cdr L))
                (list E))
                )
                ))     

                (revall '( (1 2) (3 4)))
    )V0G0N";
    string test_274 = R"V0G0N(   
            (define (distrib L E)
                (if (null? L)
                '()
                (cons (cons E (car L))
                (distrib (cdr L) E))
                )
                )   
            (distrib '(() (1) (2) (1 2)) 3) 
    )V0G0N";
    string test_275 = R"V0G0N(   
            (define (distrib L E)
                (if (null? L)
                '()
                (cons (cons E (car L))
                (distrib (cdr L) E))
                )
                ) 

            (define (extend L E)
                (append L (distrib L E))
                )  

            (extend '( () (a) ) 'b)
    )V0G0N";
    string test_276 = R"V0G0N(   
            (define (distrib L E)
                (if (null? L)
                '()
                (cons (cons E (car L))
                (distrib (cdr L) E))
                )
                ) 

            (define (extend L E)
                (append L (distrib L E))
                )  

            (define (subsets L)
                (if (null? L)
                (list '())
                (extend (subsets (cdr L))
                (car L))
                ))  

        (subsets '(1 2) )
        (subsets '(1 2 3))
          
    )V0G0N";
    string test_277 = R"V0G0N(
              (define append
                  (let ((null? null?) (car car) (cdr cdr) (cons cons))
                    (lambda args
                      ((letrec ((f (lambda (ls args)
                                    (if (null? args)
                                        ls
                                        ((letrec ((g (lambda (ls)
                                                        (if (null? ls)
                                                            (f (car args) (cdr args))
                                                            (cons (car ls) (g (cdr ls)))))))
                                            g) ls)))))
                        f) '() args))))
    )V0G0N";
    string test_278 = R"V0G0N(
              (define zero? 
                (let ((= =))
                  (lambda (x) (= x 0))))
    )V0G0N";          
    string test_279 = R"V0G0N(
              (define list (lambda x x))
    )V0G0N";
    string test_280 = R"V0G0N(
              (define list? 
                  (let ((null? null?) (pair? pair?) (cdr cdr))
                    (lambda (x)
                      (or (null? x)
                    (and (pair? x) (list? (cdr x)))))))
    )V0G0N";
    string test_281 = R"V0G0N(
              (define length
                  (let ((null? null?) (pair? pair?) (cdr cdr) (+ +))
                    (lambda (x)
                      (letrec ((count 0) (loop (lambda (lst count)
                        (cond ((null? lst) count)
                              ((pair? lst) (loop (cdr lst) (+ 1 count)))
                              (else "this should be an error, but you don't support exceptions")))))
                  (loop x 0)))))
    )V0G0N";

    string test_282 = R"V0G0N(
              (define make-string 5)
              (set! make-string
                (let ((null? null?)(make-string make-string)(car car)(= =)(length length))
                  (lambda (x . y)
                    (cond ((null? y) (make-string x #\nul))
                    ((= 1 (length y)) (make-string x (car y)))
                    (else "this should be an error, but you don't support exceptions")))))
    )V0G0N";
    string test_283 = R"V0G0N(
              (define make-vector 5)
              (set! make-vector
                (let ((length length)(make-vector make-vector)(car car)(null? null?))
                  (lambda (x . y)
                    (cond ((null? y) (make-vector x 0))
                    ((= 1 (length y)) (make-vector x (car y)))
                    (else "this should be an error, but you don't support exceptions")))))
    )V0G0N";
    string test_284 = R"V0G0N(
              (define not
                (let ((eq? eq?))
                  (lambda (x)
                    (if (eq? x #t) #f #t))))
    )V0G0N";
    string test_285 = R"V0G0N(   
                  (define float? 5)
                  (define number?
                    (let ((float? float?) (integer? integer?))
                      (lambda (x)
                        (or (float? x) (integer? x)))))
    )V0G0N";
    string test_286 = R"V0G0N(   
                  (define map
                    (let ((null? null?) (cons cons) (apply apply) (car car) (cdr cdr))
                      (lambda (f ls . more)
                        (if (null? more)
                      (let ([ls ls])
                        (letrec ((map1 (lambda (ls) 
                            (if (null? ls)
                          '()
                          (cons (f (car ls))
                                (map1 (cdr ls)))) )))
                          (map1 ls))
                        )
                      (let ([ls ls] [more more])
                        (letrec ((map-more (lambda (ls more)
                          (if (null? ls)
                              '()
                              (cons
                                (apply f (car ls) (map car more))
                                (map-more (cdr ls) (map cdr more)))))))
                          (map-more ls more))
                        )))))
    )V0G0N";
    string test_287 = R"V0G0N(   
              (define list->vector
                (let ((null? null?)(pair? pair?)(car car)(cdr cdr)(make-vector make-vector)(length length)(+ +))
                  (lambda (lst)
                    (letrec ((loop (lambda (lst vec count)
                        (cond ((null? lst) vec)
                        ((pair? lst) (loop (cdr lst) (begin (vector-set! vec count (car lst)) vec) (+ 1 count)))
                        (else "this should be an error, but you don't support exceptions")))))
                (loop lst (make-vector (length lst)) 0)))))
    )V0G0N";
    string test_288 = R"V0G0N(   
                  (define vector->list
                    (let ((< <)(vector-ref vector-ref)(cons cons)(vector-length vector-length)(- -))
                      (lambda (vec)
                        (letrec ((loop (lambda (vec lst count)
                            (cond ((< count 0) lst)
                            (else (loop vec (cons (vector-ref vec count) lst) (- count 1)))))))
                    (loop vec '() (- (vector-length vec) 1))))))
    )V0G0N";
    string test_289 = R"V0G0N(   
                  (define vector
                    (let ((list->vector list->vector))
                      (lambda x (list->vector x))))
    )V0G0N";
    string test_290 = R"V0G0N(   
                  (define + 5)
                  (define +
                    (let ((null? null?)(+ +)(car car)(apply apply)(cdr cdr))
                      (letrec ((loop (lambda x (if (null? x) 0 (+ (car x) (apply loop (cdr x)))))))
                        loop)))
    )V0G0N";
    string test_291 = R"V0G0N( 
                  (define * 5)  
                  (define *
                    (let ((null? null?)(* *)(car car)(apply apply)(cdr cdr))
                      (letrec ((loop (lambda x (if (null? x) 1 (* (car x) (apply loop (cdr x)))))))
                        loop)))
    )V0G0N";
    string test_292 = R"V0G0N(   
                (define - 5)
                (define -
                    (let ((null? null?)(- -)(+ +)(car car)(apply apply)(length length)(cdr cdr))
                      (letrec ((loop (lambda x (if (null? x) 0 (- (apply loop (cdr x)) (car x) )))))
                        (lambda num
                    (cond ((null? num) "this should be an error, but you don't support exceptions")
                          ((= (length num) 1) (- 0 (car num)))
                          (else (+ (car num) (apply loop (cdr num)))))))))
    )V0G0N";
    string test_293 = R"V0G0N(   
                  (define / 5)
                (define /
                    (let ((null? null?)(/ /)(* *)(car car)(apply apply)(length length)(cdr cdr))
                      (lambda num
                        (cond ((null? num) "this should be an error, but you don't support exceptions")
                        ((= (length num) 1) (/ 1 (car num)))
                        (else (/ (car num) (apply * (cdr num))))))))
    )V0G0N";
    string test_294 = R"V0G0N(   
                (define = 5)
                (define =
                  (let ((null? null?)(= =)(car car)(cdr cdr))
                    (letrec ((loop (lambda (element lst) (if 
                            (null? lst) 
                            #t 
                            (if 
                            (= element (car lst))
                            (loop (car lst) (cdr lst))
                            #f)
                            ))))
                      (lambda lst
                  (cond ((null? lst) "this should be an error, but you don't support exceptions")
                        (else (loop (car lst) (cdr lst))))))))
    )V0G0N";
    string test_295 = R"V0G0N(   
                  (define < 4)
                (define <
                    (let ((null? null?)(< <)(car car)(cdr cdr))
                      (letrec ((loop (lambda (element lst) (if 
                              (null? lst) 
                              #t 
                              (if 
                              (< element (car lst))
                              (loop (car lst) (cdr lst))
                              #f)
                              ))))
                        (lambda lst
                    (cond ((null? lst) "this should be an error, but you don't support exceptions")
                          (else (loop (car lst) (cdr lst))))))))
    )V0G0N";
    string test_296 = R"V0G0N(   
                (define > 4)
                (define >
                    (let ((null? null?)(< <)(= =)(not not)(car car)(cdr cdr))
                      (letrec ((loop (lambda (element lst) (if 
                              (null? lst) 
                              #t 
                              (if 
                              (not (or (< element (car lst)) (= element (car lst))))
                              (loop (car lst) (cdr lst))
                              #f)
                              ))))
                        (lambda lst
                    (cond ((null? lst) "this should be an error, but you don't support exceptions")
                          (else (loop (car lst) (cdr lst))))))))
    )V0G0N";
    string test_297 = R"V0G0N( 
                (define float? 5)  
                (define equal?
                    (let ((< <)(= =)(not not)(string-length string-length)(string-ref string-ref)(vector-ref vector-ref)(vector-length vector-length)(integer? integer?) (float? float?) (pair? pair?) (char? char?) (string? string?)(vector? vector?)(eq? eq?)(car car)(cdr cdr)(char->integer char->integer)(- -))
                      (let ((compare-composite (lambda (container-1 container-2 container-ref-fun container-size-fun)
                              (letrec ((loop (lambda (container-1 container-2 container-ref-fun 				index)
                              (if (< index 0)
                                  #t
                                  (and (equal? (container-ref-fun container-1 index) (container-ref-fun container-2 index)) (loop container-1 container-2 container-ref-fun (- index 1)))))))
                          (if (not (= (container-size-fun container-1) (container-size-fun container-2)))
                              #f
                              (loop container-1 container-2 container-ref-fun (- (container-size-fun container-1) 1)))))))
                        
                        (lambda (x y)
                    (or 
                    (and (integer? x) (integer? y) (= x y))
                    (and (float? x) (float? y) (= x y))
                    (and (pair? x) (pair? y) (equal? (car x) (car y)) (equal? (cdr x) (cdr y)))
                    (and (char? x) (char? y) (= (char->integer x) (char->integer y)))
                    (and (string? x) (string? y) (compare-composite x y string-ref string-length))
                    (and (vector? x) (vector? y) (compare-composite x y vector-ref vector-length))
                    (eq? x y))))))
      )V0G0N";
      string test_298 = R"V0G0N(   
                ; 1, dotted list..
                (cons 1 3)
                (cons 1 (cons 2 3))
                (cons 'h '())
                (cons 1 (cons 2 (cons 3 '())))
    )V0G0N";
    string test_299 = R"V0G0N(   
                ; filter function
                (define filter
                    (lambda (pred lst)
                      (if (null? lst)
                          '()
                          (if (pred (car lst))
                              (cons (car lst) (filter pred (cdr lst)))
                              (filter pred (cdr lst))))))

                (filter pair? '('(1 2) 3 4))
                (filter vector? '('#(1) 1.5 2 '#(3)))
    )V0G0N";
    string test_300 = R"V0G0N(   
                (define fold-left
                  (lambda (f acc lst)
                    (if (null? lst)
                        acc
                        (fold-left f (f acc (car lst)) (cdr lst)))))

              (fold-left + 0 '(1 2 3 4))
              (fold-left * 1 '(1 2 3 4))
    )V0G0N";
    string test_301 = R"V0G0N(   
                (define get-nth
                  (lambda (lst n)
                    (if (null? lst)
                        '()
                        (if (= n 0)
                            (car lst)
                            (get-nth (cdr lst) (- n 1))))))

              (get-nth '(1 2 3 4 5) 2)
              (get-nth '(1 2 3) 8)
    )V0G0N";
    string test_302 = R"V0G0N(   
                  ; Define map function
                    (define map
                        (lambda (f lst)
                          (if (null? lst)
                              '()
                              (cons (f 2 (car lst)) (map f (cdr lst))))))

                    (map - '(1 2 3))
                    (map * '(1 2 3))
    )V0G0N";

    string test_303 = R"V0G0N(   
                ; First car of simple list
                (define lst '(1 2 3))
                (car lst)

                ; 2, again simple string list
                (define lst2 '("hello" 'bye "helloa"))
                (car lst2)

                ;3, car of lists
                (define lst3 '((1.5 2 3) 1 2))
                (car lst3)

                ;4, car of vector
                (define lst4 '(#(1 'a) 2 3))
                (car lst4)
    )V0G0N";

    string test_304 = R"V0G0N(   
                ; First car of simple list
                (define lst '(1 2 3))
                (cdr lst)

                ; 2, again simple string list
                (define lst2 '("hello" 'bye "helloa"))
                (cdr lst2)

                ;3, car of lists
                (define lst3 '((1.5 2 3) 1 2))
                (cdr lst3)

                ;4, car of vector
                (define lst4 '(#(1 'a) 2 3))
                (cdr lst4)
    )V0G0N";

    string test_305 = R"V0G0N(   
               ; First car of simple list
                (define lst '(1 2 3))
                (car lst)
                (set-car! lst 4)
                (car lst)

                ; 2, again simple string list
                (define lst2 '("hello" 'bye "helloa"))
                (car lst2)
                (set-car! lst2 4)
                (car lst2) 

                ;3, car of lists
                (define lst3 '((1.5 2 3) 1 2))
                (car lst3)
                (set-car! lst3 "hello")
                (car lst3)

                ;4, car of vector
                (define lst4 '(#(1 'a) 2 3))
                (car lst4)
                (set-car! lst4 1)
                (car lst4)

    )V0G0N";
    string test_306 = R"V0G0N(   
               ; First car of simple list
                (define lst '(1 2 3))
                (cdr lst)
                (set-cdr! lst '(1 1 2))
                (cdr lst)

                ; 2, again simple string list
                (define lst2 '("hello" 'bye "helloa"))
                (cdr lst2)
                (set-cdr! lst2 '("bye"))
                (cdr lst2)

                ;3, car of lists
                (define lst3 '((1.5 2 3) 1 2))
                (cdr lst3)
                (set-cdr! lst3 4)
                (cdr lst3)

                ;4, car of vector
                (define lst4 '(#(1 'a) 2 3))
                (cdr lst4)
                (set-cdr! lst4 1)
                (cdr lst4)

    )V0G0N";
    string test_307 = R"V0G0N(   
               (define counter
                (let ((n 1))
                  (lambda ()
                    (set! n (+ n 1))
                      n)))

            (counter) ;; 2
            (counter) ;; 3
            (counter) ;; 4
    )V0G0N";
    string test_308 = R"V0G0N(   
               (define factor
                  (letrec ((fact 
                            (lambda (n)
                              (if (= n 0)
                                  1
                                  (* n (fact (- n 1)))))))
                    (lambda (n)
                      (fact n))))

              (factor 5)
              (factor 6)
              (factor 7)

    )V0G0N";
    string test_309 = R"V0G0N(   
               (define fibo
                (lambda (n)
                  (if (= n 0)
                      1
                      (if (= n 1)
                          1
                          (+ (fibo (- n 1)) (fibo (- n 2)))))))

            (fibo 5)
            (fibo 6)
            (fibo 7)
            (fibo 8)

    )V0G0N";
    string test_310 = R"V0G0N(   
            ; 1, Sanity test
            (let* ((x 1)
                    (y (+ 2 x)))
                (+ x y))

            ; 2, if macro expansion
            (let* ((dit (lambda () 'hi))
                    (dif (lambda () 'bye))
                    (val #t))
                ((or (and val dit) (and val-test dif))))   
    )V0G0N";
    string test_311 = R"V0G0N(   
              ; 1.1
              (define f (lambda () 1))
              (f)

              ; 1.2
              (define x 0)
              (set! x 3)
              (if #f 1 x)
              (if #t (set! x 2) 2)

              ; 1.3 
              ((lambda ()
                  ((lambda (a b c d e)
                      e) 'a 'b 'c 'd 'e)))
    )V0G0N";
    string test_312 = R"V0G0N(   
              ; String set
              (define x "h")
              (string-set! x 0 #\x)
              x

              ; String length
              (string-length "hellllllo")

              ; make string
              (make-string 4 #\y)

              ; vector length
              (vector-length '#(1 2 3 4 5))

              ; vector set
              (define vec '#(1 2 3 4 5))
              (vector-set! vec 2 6)
              vec
    )V0G0N";
    string test_313 = R"V0G0N(   
               ; Define 2 global functions..
              (define (g x) (+ x 1.5))
              (define f (lambda (y) y))

              (g 1.5)
              (f 'hello)
              (f "hello")
              (f (g 1.5))
              (g (f 2.5))

    )V0G0N";
    string test_314 = R"V0G0N(   
       '(1 #(1 2 3)) 
    )V0G0N";
    string test_315 = R"V0G0N(   
        'hello
        'world
        'bye
        'world
    
    )V0G0N";
    string test_316 = R"V0G0N(   
        '(moomy said you are stupid)       
    )V0G0N";
    string test_317 = R"V0G0N(   
         1
        1.1
        1e-1
        '()
        #t
        #f
        "Hello World!"
        'hello 'world
        '(1 2 3)
        '#(1 2 3)
    )V0G0N";
    string test_318 = R"V0G0N(   
           '(1 2 (1 2 3))
          '("hello" 'hello #(#t #f 2e-3))
    )V0G0N";
    string test_319 = R"V0G0N(   
           (and (if #f 1 '(1 2)) (if #t '(1 2) 1))
          (and 'yay (if 1 2 3) (if 1 2))
    
    )V0G0N";
    string test_320 = R"V0G0N(   
          (and (begin 1e-2) 1.1111)     
    )V0G0N";
    string test_321 = R"V0G0N(   
           (and (begin 1 2 3) (begin 1))
          (and (and (and 1)))
          (and (if 1 (begin 34 5)) (begin 3))
    )V0G0N";
    string test_322 = R"V0G0N(   
          (and 1 2 3)
     
    )V0G0N";
    string test_323 = R"V0G0N(   
          (and)
          (and 1)
      
    )V0G0N";
    string test_324 = R"V0G0N(   
        (if "dalit" "amazing" "shmena")
    
    )V0G0N";
    string test_325 = R"V0G0N(   
         ; part of fact function
        (if 0 1 23)

        #;"hello"
        1
      
    )V0G0N";
    string test_326 = R"V0G0N(   
        (if (if "wow" #f 2) 3 4)
        (if (if #f #f #t) 1 2)
        (if 1 (if 2 (if #f 3 4)) "dontcare" )
       
    )V0G0N";
    string test_327 = R"V0G0N(   
         (if (begin 1 2 3) 'hello 'bye)
         (if (begin 1 2 #f) 'bye 'hello)
      
    )V0G0N";
    string test_328 = R"V0G0N(   
         (if #f 1 2)
      
    )V0G0N";
    string test_329 = R"V0G0N(   
         (if #t 1 2)
      
    )V0G0N";
    string test_330 = R"V0G0N(   
         ((lambda (a lst . b) (a lst b)) cons '(1) 2 3 4 '(9) 'hello)
      
    )V0G0N";
    string test_331 = R"V0G0N(   
         (define list
            (lambda l
              l))

          ;; With params
          (list 1 2 3)

          ;; without params
          (list)

          ;;; list with mandatory params
          (define list2 (lambda (x . l) l))

          (list2 1 2 3)
          (list2 1.5 2 1.7)
          (list2 "Hello" 'world "Bye")
          (list2 1)

      
    )V0G0N";
    string test_332 = R"V0G0N(   
          (define list
            (lambda l
              ((lambda (x) (cons x l)) 4)))

        (list 1 2 3 4 5)
        (list)

        (define list
            (lambda (a . l)
              ((lambda () l))))

        (list 1 2 3 4 5)

        (list 1)
     
    )V0G0N";
    string test_333 = R"V0G0N(   
         (define list 
          (lambda l l))

        ((lambda (a b . c)
          ((lambda (a b . c) (list a b c))
            c b a))
        1 2 3)
      
    )V0G0N";
    string test_334 = R"V0G0N(   
         (if (or #t "dalse")
          (begin 'display 'x 'x)
          (begin 'display 'y 'y))
        (if (and #f "false")
          (begin 'display "x" 'x)
          (begin 'display "y" 'y))
        (if (or (and 3 4 5) 1 2)
          (and 3 4)
          (or 567 5))
      
    )V0G0N";
    string test_335 = R"V0G0N(   
         (or (and 'of 'ir) 1 (and (or 2)))
          (and (or 1 2) (or 3))
          (or 1 2 (or 3))
     
    )V0G0N";
    string test_336 = R"V0G0N(   
           (begin (or 12 1) (or 1) (and 1 2) (and 1))
            (begin (or 11 (and 1 2) 1))
            (begin (or 11 (and 1 2) 1) 1 2)
            (begin (and 11 (or 1 2) 1))
            (begin (and 11 (or 1 2) 1) 1 2)

    
    )V0G0N";
    string test_337 = R"V0G0N(   
            (or 1 2 3)
            (or)
            (or 'hllo)
            (or #t)
              
    )V0G0N";
    string test_338 = R"V0G0N(   
            (begin 1 2 3 4 5 6 7 8)
   
    )V0G0N";
    string test_339 = R"V0G0N(   
            (begin 1 2 3 45)
            (begin #t #f '#('hello))
  
    )V0G0N";
    string test_340 = R"V0G0N(   
            (begin 'hello-world)
   
    )V0G0N";
    string test_341 = R"V0G0N(   
            (begin)
   
    )V0G0N";
    string test_342 = R"V0G0N(   
           (begin 'dalit 'im 'runing)
          (begin `yayyy)
    
    )V0G0N";
    string test_343 = R"V0G0N(   
          (begin 1 1)
          (begin (begin 1 2 3) "Hello")
          (begin (begin 1 2) (begin 3 4))
          (begin 1 (begin 3 4))
     
    )V0G0N";
    string test_344 = R"V0G0N(   
          (begin 1.1 2.1 (if #t 10.4))
     
    )V0G0N";
    string test_345 = R"V0G0N(   
           (begin 12 12 (begin 'hello) (begin 12 13) 1)
    
    )V0G0N";
    string test_346 = R"V0G0N(   
           (append '(1 2) '(3 4))
    
    )V0G0N";
    string test_347 = R"V0G0N(   
           (define n 1)
          (= n 1)
          (= n 2)
    
    )V0G0N";
    string test_348 = R"V0G0N(   
          (equal? 1 1)
          (equal? '(1 2) '(1 2))
          (equal? '(1 3) '(1 2))

     
    )V0G0N";
    string test_349 = R"V0G0N(   
          (> 1 2)
          (> 2 1 3)
    
    )V0G0N";
    string test_350 = R"V0G0N(   
           (< 1 2)
          (< 2 1 3)
    
    )V0G0N";
    string test_351 = R"V0G0N(   
           (length '(1 2 3 4))
    
    )V0G0N";
    string test_352 = R"V0G0N(   
           (define lst '(1 2 3))
            (define lst1 '(#t #f #t))
            (define lst2 '(1.5 1e-1))

            (list? lst)
            (list? lst1)
            (list? lst2)

            (list 1 2 3)
            (list 1.5 1e-1)

    
    )V0G0N";

    string test_353 = R"V0G0N(   
          (list->vector '(1 'hello))
 
    )V0G0N";
    string test_354 = R"V0G0N(   
           (make-string 4 #\a)

            (make-string 4 #\newline)

            (make-string 4 #\space)

    )V0G0N";
    string test_355 = R"V0G0N(   
           (make-vector 4 1)

    )V0G0N";
    string test_356 = R"V0G0N(   
           (not #t)
            (not #f)

    )V0G0N";
    string test_357 = R"V0G0N(   
           (number? 1)
          (number? 1e-1)
          (number? "hello")


    )V0G0N";
    string test_358 = R"V0G0N(   
           (vector 1 2 3 4)

    )V0G0N";
    string test_359 = R"V0G0N(   
          (vector->list (list->vector '(1 'hello)))
 
    )V0G0N";
    string test_360 = R"V0G0N(   
           (zero? 0)

            (zero? 1)

    )V0G0N";
    string test_361 = R"V0G0N(   
           ; 1, Box simple lambda for lazy return 1
          ((lambda (x)
                    x
                    ((lambda (y)
                            (set! x (lambda () 1))
                            (+ y (x))) 2) )1)

          ; 2, Box lazy lambda
          ((lambda (x)
                    x
                    ((lambda (y)
                            (set! x (lambda () +))
                            ((x) y 1)) 2) )1)


    )V0G0N";
    string test_362 = R"V0G0N(   
           ; Define fact function, tested by chez..
            (define fact
                (lambda (n)
                  (if (= n 0)
                      1
                      (* n (fact (- n 1))))))

            (fact 5) ; should return 120
            (fact 4) ; should return 24
            (fact 6) ; Dont remmber....

    )V0G0N";
    string test_363 = R"V0G0N(   
          ; 1, override bound by param.
        ((lambda (x)
            ((lambda (x)
                x) 1)) 2)

        ;2, override by bound.
        ((lambda (x)
            ((lambda (x)
                ((lambda (y)
                  (+ x y)) 1)) 2)) 3)
 
    )V0G0N";
    string test_364 = R"V0G0N(   
          ; 1, simple test summarize 2 bounds params..
          (((lambda (x y) (lambda () (+ y x))) 1.5 2.5))

          ; 2, Summarize and set! for bounds..
          (((lambda (x y) 
            (lambda () (set! x y) 
              (+ (+ x x) y))) 
            1 2))

          ; 3, override param and aply on 2 bounds..
          ((lambda (x y) 
            ((lambda (z) 
              (set! z +) 
              (z x y)) 
              1)) 
            1.5 4.5)


 
    )V0G0N";
    string test_365 = R"V0G0N(   
          ;; First test simple Box test for x
        ((lambda (x)
            (set! x 1)
            ((lambda ()
                x))) 2)

        ;; Second tests simple Box test for x
        ((lambda (x)
            ((lambda ()
                (set! x 'hello)))
          x) 2)

        ; Third test 1 box and 1 not
        (define (f x y) x ((lambda () (set! x y) x)))
        (f 1 2)

        ; Fourth test 2 boxes..
        (define (g x y) x (set! y 3.5) ((lambda () (set! x 2.5) (+ x y))))
        (g 1 2)

    )V0G0N";
    string test_366 = R"V0G0N(   
         ; First test, simple define and print out..
          (define x 2)
          x

          ; Second test, LambdaSimple and apply on number..
          (define (y l) l)
          (y 2)

          ; Third test, override define global funtction...
          (define + *)
          (+ 2 3)

          ; Fourth again simple one..
          (define x (lambda (y) y))
          (x 3)

          ; Last one override define free var in run-time..
          (define x x)
          (x 3)
  
    )V0G0N";
    string test_367 = R"V0G0N(   
           ; First test, simple test define lambda with 1 paramter
          ((lambda (x) (begin (set! x 3) x)) 4)

          ; Second define global and override..
          (define x 2)
          ((lambda () (set! x 3)))
          x

          ; Third use param within lambda as parent..
          ((lambda () ((lambda (y) y) 2)))

          ; 4, Simple test for getting param.
          ((lambda (x) x) 1)
          ((lambda (x y) (+ x y)) 2.5 4.5)
          ((lambda (p) p) "HEllo")
          ((lambda (str) (string-set! str  0 #\x) str) "h")
          ((lambda (vec) (vector-length vec)) '#(1 2 3 4 5))
    )V0G0N";
    string test_368 = R"V0G0N(   
           ; 1, triple lambdas.. 
          ((lambda (x)
              ((lambda (y)
                  ((lambda (z)
                    (* (+ x y) z)) 2)) 3)) 4)

          ; 2, four lamds..
          ((lambda (x)
              ((lambda (y)
                  ((lambda (z)
                    ((lambda (a)
                        (* a (+ y (* z x)))) 2)) 3)) 4)) 5)

          ; 3, five lamds..
          ((lambda (a)
              ((lambda (b)
                  ((lambda (c)
                    ((lambda (d)
                        ((lambda (e)
                          (+ a (- b (+ c (- e d))))) 1)) 2)) 3)) 4)) 5)

    )V0G0N";
    string test_369 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 
    )V0G0N";
    string test_370 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

          (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))
        
              (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))
              (even? 5)
              (even? 4)
              (odd? 2)
              (odd? 15) 
    )V0G0N";
    string test_371 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define list-ref
          (lambda (ls n)
            (if (= n 0)
                (car ls)
                (list-ref (cdr ls) (- n 1))))) 

      (list-ref '(a b c) 0)
      (list-ref '(a b c) 1) 
      (list-ref '(a b c) 2)
    )V0G0N";
    string test_372 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

        (define list-tail
        (lambda (ls n)
          (if (= n 0)
              ls
              (list-tail (cdr ls) (- n 1))))) 




    (list-tail '(a b c) 0)
    (list-tail '(a b c) 2)
    (list-tail '(a b c) 3) 
    (list-tail '(a b c . d) 2)
    (list-tail '(a b c . d) 3) 
    (let ([x (list 1 2 3)])
      (eq? (list-tail x 2)
          (cddr x)))   
    )V0G0N";
    string test_373 = R"V0G0N(   
        (define caar (lambda (pair) (car (car pair))))
        (define cadr (lambda (pair) (car (cdr pair))))
        (define cddr (lambda (pair) (cdr (cdr pair))))
        (define cdar (lambda (pair) (cdr (car pair))))
        (define caaar (lambda (pair) (car (caar pair))))
        (define caadr (lambda (pair) (cdr (car pair))))
        (define cdaar (lambda (pair) (cdr (caar pair))))
        (define cdadr (lambda (pair) (cdr (cadr pair))))
        (define cddar (lambda (pair) (cdr (cdar pair))))
        (define cdddr (lambda (pair) (cdr (cddr pair)))) 

        (define list?
        (lambda (x)
          (letrec ([race
                    (lambda (h t)
                      (if (pair? h)
                          (let ([h (cdr h)])
                            (if (pair? h)
                                (and (not (eq? h t))
                                    (race (cdr h) (cdr t)))
                                (null? h)))
                          (null? h)))])
            (race x x))))

        (define make-cyclic-pair (lambda (first second) 
                (let ([lst (list first second '())])
                (set-cdr! (cdr lst) lst) lst)))

        (define cyc-pair (make-cyclic-pair 'a 1))
        (list? cyc-pair)
        (list? '(1 2 3 4 6 6 8 #\a "ef"))   
    )V0G0N";
    string test_374 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

         (define reverse
          (lambda (ls)
            (letrec ([rev (lambda (ls new)
              (if (null? ls)
                  new
                  (rev (cdr ls) (cons (car ls) new))))])
              (rev ls '()))))

      (reverse '(1 2 3 4))
      (reverse '(12 4 "sf" #t))  
    )V0G0N";
    string test_375 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

          (define memq
          (lambda (x ls)
            (cond
              [(null? ls) #f]
              [(eq? (car ls) x) ls]
              [else (memq x (cdr ls))])))


      (memq 'a '(b c a d e))
      (memq 'a '(b c d e g)) 
          
      (define count-occurrences
        (lambda (x ls)
          (cond
            [(memq x ls) =>
            (lambda (ls)
              (+ (count-occurrences x (cdr ls)) 1))]
            [else 0])))

      (count-occurrences 'a '(a b c d a)) 
    )V0G0N";
    string test_376 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define member
            (lambda (x ls)
              (cond
                [(null? ls) #f]
                [(equal? (car ls) x) ls]
                [else (member x (cdr ls))])))
        (member '(b) '((a) (b) (c)))
        (member '(d) '((a) (b) (c))) 
        (member "b" '("a" "b" "c"))


        (let ()
          (define member?
            (lambda (x ls)
              (and (member x ls) #t)))
          (member? '(b) '((a) (b) (c))))
    )V0G0N";
    string test_377 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define memp (lambda (p lst)
            (if (null? lst)
                #f 
                (if (p (car lst))
                    lst
                    (memp p (cdr lst))))))

            (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))
            
            (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))

    (memp odd? '(1 2 3 4))
    (memp even? '(1 2 3 4))
    (let ([ls (list 1 2 3 4)])
      (eq? (memp odd? ls) ls)) 
    (let ([ls (list 1 2 3 4)])
      (eq? (memp even? ls) (cdr ls))) 
    (memp odd? '(2 4 6 8))
    )V0G0N";
    string test_378 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

         (define remq (lambda (obj lst)
                (if (null? lst)
                '()
                (let* ([hd (car lst)] [tl (cdr lst)] [rest (lambda () (remq obj tl))])
                    (if (eq? obj hd)
                        (rest)
                        (cons hd (rest)))))))
        (remq 'a '(a b a c a d))
        (remq 'a '(b c d))   
    )V0G0N";
    string test_379 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

        (define remove (lambda (obj lst)
        (if (null? lst)
        '()
        (let* ([hd (car lst)] [tl (cdr lst)] [rest (lambda () (remove obj tl))])
            (if (equal? obj hd)
                (rest)
                (cons hd (rest)))))))


        (remove '(b) '((a) (b) (c))) 
    )V0G0N";
    string test_380 = R"V0G0N(   
           (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define filter (lambda (p lst)
                      (if (null? lst)
                      '()
                      (let* ([hd (car lst)] [tl (cdr lst)] [rest (lambda () (filter p tl))])
                          (if (p hd)
                              (cons hd (rest))
                              (rest))))))
            
            (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))

            (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))

      (filter odd? '(1 2 3 4))
      (filter
        (lambda (x) (and (> x 0) (< x 10)))
        '(-5 15 3 14 -20 6 0 -9))
    )V0G0N";
    string test_381 = R"V0G0N(   
           (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

        (define filter (lambda (p lst)
                    (if (null? lst)
                    '()
                    (let* ([hd (car lst)] [tl (cdr lst)] [rest (lambda () (filter p tl))])
                        (if (p hd)
                            (cons hd (rest))
                            (rest))))))

           (define remp (lambda (p lst)
                        (filter (lambda (x) (not (p x))) lst)))
            
            (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))

            (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))

        (remp odd? '(1 2 3 4)) 
        (remp
          (lambda (x) (and (> x 0) (< x 10)))
          '(-5 15 3 14 -20 6 0 -9)) 
    )V0G0N";
    string test_382 = R"V0G0N(   
           (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define find (lambda (p lst)
                        (if (null? lst)
                        #f
                        (let* ([hd (car lst)] [tl (cdr lst)] [rest (lambda () (find p tl))])
                            (if (p hd)
                                hd
                                (rest))))))
            
            (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))
            
            (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))
                

        (find odd? '(1 2 3 4)) 
        (find even? '(1 2 3 4))
        (find odd? '(2 4 6 8)) 
    )V0G0N";
    string test_383 = R"V0G0N(   
           (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define assq
                (lambda (x ls)
                  (cond
                    [(null? ls) #f]
                    [(eq? (caar ls) x) (car ls)]
                    [else (assq x (cdr ls))])))

            (assq 'b '((a . 1) (b . 2)))
            (cdr (assq 'b '((a . 1) (b . 2))))
            (assq 'c '((a . 1) (b . 2)))
    )V0G0N";
    string test_384 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

            (define assq
                (lambda (x ls)
                  (cond
                    [(null? ls) #f]
                    [(eq? (caar ls) x) (car ls)]
                    [else (assq x (cdr ls))])))

           (define assoc
              (lambda (x ls)
                (cond
                  [(null? ls) #f]
                  [(equal? (caar ls) x) (car ls)]
                  [else (assq x (cdr ls))])))

                  


          (assoc '(a) '(((a) . a) (-1 . b)))
          (assoc '(a) '(((b) . b) (a . c)))
    )V0G0N";
    string test_385 = R"V0G0N(   
           (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define assp (lambda (p lst)
                          (cond 
                              [(null? lst) #f]
                              [(p (caar lst)) (car lst)]
                              [else (assp p (cdr lst))])))
            
            (define even?
                        (lambda (x)
                          (or (= x 0)
                              (odd? (- x 1)))))
            
            (define odd?
              (lambda (x)
                (and (not (= x 0))
                      (even? (- x 1)))))

          (assp odd? '((1 . a) (2 . b)))  
          (assp even? '((1 . a) (2 . b)))  
          (let ([ls (list (cons 1 'a) (cons 2 'b))])
            (eq? (assp odd? ls) (car ls))) 
          (let ([ls (list (cons 1 'a) (cons 2 'b))])
            (eq? (assp even? ls) (cadr ls)))
          (assp odd? '((2 . b)))
    )V0G0N";
    string test_386 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define char-upcase (lambda (c) (integer->char (- (char->integer c) 32))))
          (define char-downcase (lambda (c) (integer->char (+ (char->integer c) 32))))
          (char-upcase #\a)
          (char-upcase #\r)
          (char-downcase #\A)
    )V0G0N";
    string test_387 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

          (define list->string
          (lambda (ls)
            (let* ( [i 0] [s (make-string (length ls))] )
                  (letrec ([loop (lambda (ls i)
                      (if  (null? ls)
                          s
                          (begin 
                              (string-set! s i (car ls)) 
                              (loop (cdr ls) (+ i 1)))))])
                          (loop ls i)))))
        (list->string '())
        (list->string '(#\a #\b #\c))
        (list->string '(#\s #\f #\s #\g #\g #\r #\e #\r)) 
    )V0G0N";
    string test_388 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

            (define list->string
          (lambda (ls)
            (let* ( [i 0] [s (make-string (length ls))] )
                  (letrec ([loop (lambda (ls i)
                      (if  (null? ls)
                          s
                          (begin 
                              (string-set! s i (car ls)) 
                              (loop (cdr ls) (+ i 1)))))])
                          (loop ls i)))))
                          
            (define string->list 
            (lambda (s)
            (let* ( [i 0] )
                  (letrec ([loop (lambda (s i)
                      (if  (= i (string-length s))
                          '()
                              (cons (string-ref s i) (loop s (+ i 1)))))])
                          (loop s i)))))
            
            (define char-upcase (lambda (c) (integer->char (- (char->integer c) 32))))
          (define char-downcase (lambda (c) (integer->char (+ (char->integer c) 32))))
          
        (string->list "")
        (string->list "abc")
        (map char-upcase (string->list "abc"))
        (list->string (map char-downcase (string->list "SFSGGRER"))) 
    )V0G0N";
    string test_389 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

         (define factorial
          (lambda (n)
          (letrec ([fact (lambda (i)
              (if (= i 0)
                  1
                  (* i (fact (- i 1)))))])
                  (fact n))))
        
        (factorial 0)  
        (factorial 1) 
        (factorial 2)  
        (factorial 3) 
        (factorial 10)  
    )V0G0N";
    string test_390 = R"V0G0N(   
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

           (define factorial-iter
          (lambda (n)
            (letrec ([fact (lambda (i a)
              (if (= i 0)
                  a
                  (fact (- i 1) (* a i))))])
                  (fact n 1))))

        (factorial-iter 0)  
        (factorial-iter 1) 
        (factorial-iter 2)  
        (factorial-iter 3) 
        (factorial-iter 10) 
    )V0G0N";
    string test_391 = R"V0G0N( 
          (define caar (lambda (pair) (car (car pair))))
          (define cadr (lambda (pair) (car (cdr pair))))
          (define cddr (lambda (pair) (cdr (cdr pair))))
          (define cdar (lambda (pair) (cdr (car pair))))
          (define caaar (lambda (pair) (car (caar pair))))
          (define caadr (lambda (pair) (cdr (car pair))))
          (define cdaar (lambda (pair) (cdr (caar pair))))
          (define cdadr (lambda (pair) (cdr (cadr pair))))
          (define cddar (lambda (pair) (cdr (cdar pair))))
          (define cdddr (lambda (pair) (cdr (cddr pair)))) 

         (define product$
          (lambda (ls k)
            (let ([break k])
              (letrec ([f (lambda (ls k) 
                (cond
                  [(null? ls) (k 1)]
                  [(= (car ls) 0) (break 0)]
                  [else (f (cdr ls)
                          (lambda (x)
                            (k (* (car ls) x))))]))])
                (f ls k)))))

        (product$ '(1 2 3 4 5) (lambda (x) x))
        (product$ '(7 3 8 0 1 9 5) (lambda (x) x))
        (product$ '(7 3 8 1 1 912 5) (lambda (x) x))  
    )V0G0N";
    string test_392 = R"V0G0N(   
          `(#\a "hello")
    )V0G0N";
    string test_393 = R"V0G0N(   
          '#(2 (2 . 4))
    )V0G0N";
    string test_394 = R"V0G0N(   
          (if (zero? 0)
            (or #f #t)
            0)
    )V0G0N";
    string test_395 = R"V0G0N(   
          (define x (+ 2))
            ((lambda (x) 
              (set! x (+ 2 3))
              x) x)
	
    )V0G0N";
    string test_396 = R"V0G0N(   
          (letrec ((loop (lambda (r)
            (if (= r 0)
              0
              (loop (- r 1))))))
      (loop 220000))
	
    )V0G0N";
    string test_397 = R"V0G0N(   
          (letrec ((loop (lambda (r)
            (if (= r 0)
              0
              (loop (- r 1))))))
      (loop 220000))
	
    )V0G0N";
    string test_398 = R"V0G0N(   
                    (eq? ((lambda (x . y)
            (cons x y)) 'a 'b 'c 'd)
            '(a b c d))
	
    )V0G0N";
    string test_399 = R"V0G0N(   
                    ((lambda x
                      (map + x))
                    (/ 10.0 5.0) (/ 2.0 2.0) (/ 4.0 8.0) (* 16.0 23.0))
	
    )V0G0N";
    string test_400 = R"V0G0N(   
          (define a 'alpha)
          (define b 'beta)

          ((lambda (x y)
            (begin
              (set! y  "alpha")
              (eq? x y))) a b)
	
    )V0G0N";
    string test_401 = R"V0G0N(   
            (define a 'alpha)
            (define b 'beta)

            ((lambda (x y)
              (set! y a)
              (eq? a b)) a b)
	
    )V0G0N";
    string test_402 = R"V0G0N(   
            (apply - `(3 ,@(append '(4 4) '(4))))
	
    )V0G0N";
    string test_403 = R"V0G0N(   
            (define foo
            (lambda (n e)
              (if (= 0 (/ n 2))
                (foo (/ n 2) (+ e 1))
                e)))

            (foo 64 0)
	
    )V0G0N";
    string test_404 = R"V0G0N(   
            (define rocket (char->integer #\r))
            (define frily (char->integer #\f))

            (not (> rocket frily))
	
    )V0G0N";
    string test_405 = R"V0G0N(   
            (define sfx
            (lambda (bool)
              (if bool 
                  (lambda (v s i)
                    (vector-set! v i (string-ref s i))
                    v)
                  (lambda (v s i)
                    (string-set! s i (vector-ref v i))
                    s))))

        (let ((vec (make-vector 5 #\a))
            (str (make-string 5 #\b)))
          (cons ((sfx #t) vec str 3) ((sfx #f) vec str 2)))
	
    )V0G0N";
    string test_406 = R"V0G0N(   
                      (let ((baf (lambda (f)
                        (lambda (n)
                          (if (> n 0)
                              `(* ,n ,((f f) (- n 1)))
                               "end")))))
              ((baf baf) 3))
	
    )V0G0N";
    string test_407 = R"V0G0N(   
                      (define fraction? (lambda (x) (and (number? x) (not (integer? x)))))

                      ((lambda (x)
                          (cond 
                            ((integer? x) "integer")
                            ((fraction? x) "fraction")
                            ((char? x) "char")
                            ((symbol? x) "symbol")
                            ((boolean? x) "boolean")
                            ((procedure? x) "procedure")
                            (else "nothing"))) 'x)
	
    )V0G0N";
    string test_408 = R"V0G0N(   
                      (define foo (lambda (x)
                      (cons
                        (begin (lambda () (set! x 1) 'void))
                        (lambda () x))))
              (define p (foo 2))

              (define x ((cdr p)))
              (define y ((car p)))
              (define z ((cdr p)))


              (cons  x (cons y (cons z'())))
		
	
    )V0G0N";
    string test_409 = R"V0G0N(   
                      (((((lambda (x)
                      (lambda (y)
                        (lambda (z)
                          (lambda w
                            (append x y z w))))) '(a)) '(b)) '(c)) 'd 'e)
		
	
    )V0G0N";
    string test_410 = R"V0G0N(   
                      (define foo (lambda (x)
                      (let ((x (+ x 1)))
                        (lambda (y)
                          (let ((y (+ y 1)))
                            (lambda (z) 
                              (+ x y z)))))))
                              
                    (define f1 (foo 1))
                    (define f12 (f1 2))
                    (f12 3)
			
		
	
    )V0G0N";
    string test_411 = R"V0G0N(   
                      (let ((x 1))
                      (eq? (if #f #f) (set! x 2)))
		
    )V0G0N";
    string test_412 = R"V0G0N(   
                      (if (eq? '() (cdr (list 1))) 'ok 'Wrong)
		
    )V0G0N";
    string test_413 = R"V0G0N(   
                      (map map (list 
                      (lambda (x) (+ x x)) 
                      (lambda (x) (- x))
                      (lambda (x) (* x x)) 
                      (lambda (x)  (/ x)))
                '((1 2) (3 4) (5.0 6.0) (16.0 8.0)))
		
    )V0G0N";
    string test_414 = R"V0G0N(   
                      (define length
                      (lambda (l)
                        (if (null? l) 0
                          (+ 1 (length (cdr l))))))

                    (= (length ''''''''a) (length ``````````a))
		
    )V0G0N";
    string test_415 = R"V0G0N(   
                      (define (foo i)
                                (* i i))
                                
                      (+ (foo 0) (foo 1) (foo 2) (foo 3) (foo 4))
		
    )V0G0N";
    string test_416 = R"V0G0N(   
                      (define str (make-string 5 #\space))

                      (string-set! str 0 #\t)
                      (string-set! str 1 #\tab)
                      (string-set! str 3 #\n) 
                      (string-set! str 4 #\newline)

                      str
		
    )V0G0N";
    string test_417 = R"V0G0N(   
                      (define ascii 
                      (lambda ()
                        (letrec ((loop (lambda (i)
                                (if (< i 127)
                                  (cons (integer->char i) (loop (+ 1 i)))
                                  '()))))
                          (loop (char->integer #\space)))))

                    (ascii)
		
    )V0G0N";
    string test_418 = R"V0G0N(   
                      (define list? (lambda (x)
                      (or (null? x) (and (pair? x) (list? (cdr x))))))

                    (define describe
                      (lambda (e)
                        (cond
                        ((list? e) `(list ,@(map describe e)))
                        ((pair? e) `(cons ,(describe (car e))
                            ,(describe (cdr e))))
                        ((or (null? e) (symbol? e)) `',e)
                        (else e))))
                        
                    (describe '(sym "str" #\c 1))
		
    )V0G0N";
    string test_419 = R"V0G0N(   
                      (define Y 
                      (lambda (foo)
                      ((lambda (f) (foo (lambda (x) ((f f) x))))
                        (lambda (f) (foo (lambda (x) ((f f) x)))))))

                    (define max
                      (Y (lambda (f)
                        (lambda (l)
                          (if (null? l) 0
                            (let ((cdr-max (f (cdr l))))
                              (if (> (car l) cdr-max) (car l) cdr-max)))))))
                    (define depth
                      (lambda (f)
                        (lambda (t)
                          (if (pair? t)
                            (+ 1 (max (map f t)))
                            0))))

                    ((Y depth) '((1 2 3) (4 (5 (6))) (((((7 (8) 9 10 11 12) 13) 14)))))
		
    )V0G0N";
    string test_420 = R"V0G0N(   
                      ((lambda (a1 a2 a3 a4 a5)
                      ((lambda (b1 b2 b3 b4)
                          ((lambda (c1 c2 c3)
                            ((lambda (d1 d2)
                                ((lambda (e1) 
                                  e1) d1)) c1 c2)) b1 b2 b3)) a1 a2 a3 a4)) 
                    1 2 3 4 5)
		
    )V0G0N";
    string test_421 = R"V0G0N(   
                      (((lambda (x) 
                      (lambda (y . z) 
                        (if `notbool (+ (+ x  (* y (car z)) (car (cdr z))) 9)))) 8) 10 11 12)
		
    )V0G0N";
    string test_422 = R"V0G0N(   
                       (and
                          (boolean? #t)
                          (boolean? #f)
                          (not (boolean? 1234))
                          (not (boolean? 'a))
                          (symbol? 'b)
                          (eq? (car '(a b c)) 'a)
                          (= (car (cons 1 2)) 1)
                          (integer? 1234)
                          (char? #\a)
                          (null? '())
                          (string? "abc")
                          (symbol? 'lambda)
                          (vector? '#(1 2 3))
                          (not (vector? 1234))
                          (not (string? '#(a b c)))
                          (not (string? 1234))
                          (= 3 (vector-length '#(a #t ())))
                          (pair? '(a . b))
                          (not (pair? '()))
                          (zero? 0)
                          (not (zero? 234))
                          (= 97 (char->integer (string-ref "abc" 0)))
                          (let ((n 10000))
                            (= n (string-length (make-string n))))
                          (let ((n 10000))
                            (= n (vector-length (make-vector n))))
                          (let ((v '#(a b c)))
                            (eq? 'c (vector-ref v 2)))
                          (= 65 (char->integer #\A))
                          (let ((string (make-string 2)))
                            (string-set! string 0  #\h)
                            (string-set! string 1  #\nul)
                            (eq? 'ab string))
                          (= 3 (+ 7 4))
                          (= 6 (* 1 2 3))
                          (= 234 (* 234))
                          (= 6 (+ 1 2 3))
                          (= 234 (+ 234))
                          (= 1 (- 6 3 2))
                          (< 1 2 3 4 5)
                          (> 5 4 3 2 1)
                          )
		
    )V0G0N";
    string test_423 = R"V0G0N(   
            (define andmap (lambda (p lst)
            (or (null? lst)
                (and (p (car lst)) (andmap p (cdr lst)))) ))
    ; make-matrix creates a matrix (a vector of vectors).
    ; make-matrix creates a matrix (a vector of vectors).
    (define make-matrix
    (lambda (rows columns)
    (letrec ([loop (lambda (m i)
    (if (= i rows)
        (begin m)
        (begin
            (vector-set! m i (make-vector columns))
            (loop m (+ i 1)))))])
    (loop (make-vector rows) 0)))) 

    )V0G0N";
    string test_424 = R"V0G0N(   
                  ((lambda ()
                  ((lambda s
                    ((lambda ()
                      ((lambda s s) s s s))))
                  #t)))
    )V0G0N";
    string test_425 = R"V0G0N(   
                              (map (lambda (x) (apply x '(()))) ((lambda ()
              `(,(lambda (a) 1)
                ,(lambda (b) 2)
                ,(lambda (c) 3)
                ,(lambda (d) 4)
                ,(lambda (e) 5)
                ,(lambda (f) 6)
                ,(lambda (g) 7)
                ,(lambda (h) 8)
                ,(lambda (i) 9)
                ,(lambda (j) 10)
                ,(lambda (k) 11)
                ,(lambda (l) 12)
                ,(lambda (m) 13)
                ,(lambda (n) 14)
                ,(lambda (o) 15)
                ,(lambda (p) 16)
                ,(lambda (q) 17)
                ,(lambda (r) 18)
                ,(lambda (s) 19)
                ,(lambda (t) 20)
                ,(lambda (u) 21)
                ,(lambda (v) 22)
                ,(lambda (w) 23)
                ,(lambda (x) 24)
                ,(lambda (y) 25)
                ,(lambda (z) 26)))))
    )V0G0N";
    string test_426 = R"V0G0N(   
                  (define a (string-length "b"))
                  (define b (string-length "c"))
                  (define c (string-length "d"))
                  (define d (string-ref "esadsad" 3))
                  (define e (string-ref "fsfdsaf3dfss" 10))
                  (define f (string-ref "g" 0))
                  (define g (string-length "dsfdsh"))
                  (define h (string-length "idfdsfds"))
                  (define i (string-length "jdsfdsf"))
                  (define j (string-length "kdsfdsf"))
                  (define k (string-length "lds"))
                  (define l (string-length "mdsff"))
                  (define m (string-length "nd"))
                  (define n (string-length ""))
                  (define o (string-length "pdsfdsf"))
                  (define p (string-ref "q34324dsfdsfdsf35r" 6))
                  (define q (string-ref "rdfsfdsf3rfdsfdsf" 8))
                  (define r (string-ref "sfddsfr4fdfdsfdsgfdgfdh" 14))
                  (define s (string-ref "tdfsdsf34sfddsf" 11))
                  (define t (string-ref "uffdsfds43sfdfds" 8))
                  (define u (string-ref "vdsfdsfdsf4dsfsdf" 9))
                  (define v (string-ref "wdsfdsfdsf3fsd" 6))
                  (define w (string-length "xff"))
                  (define x (string-length "dfsy"))
                  (define y (string-length "zdfs"))
                  (define z (string-length "asdfds"))

                  (eq? 'a z)
    )V0G0N";
    string test_427 = R"V0G0N(   
                  (define foo (lambda (n) 
                    (if (= n 0)
                        'finish
                        (foo (- n 1))
                    )
                  )
                  )

          (foo 1000000)
    )V0G0N";
    string test_428 = R"V0G0N(   
                  '#(#\v #(#\e #(#\c #(#\t #(#\o #(#\r #(#\s #(#\o #\f) #\v) #\e) #\c) #\t) #\o) #\r) #\s)
    )V0G0N";
    string test_429 = R"V0G0N(   
                  (/ (+ (* 1.0 5.0) (* 2.0 (- (* 4.0 6.0) (* 8.0 30.0))) (* 1.0 2.0)) -425.0)
    )V0G0N";
    string test_430 = R"V0G0N(   
                  (and (integer? (- (/ 7 6) (/ (/ 1 3) 2))) (integer? (+ (/ (- 5) 6) (/ (/ 1 3) (- 2)))))
    )V0G0N";
    string test_431 = R"V0G0N(   
                  (define cons (lambda (x y) 
                  (lambda (f) 
                    (f x y))))
              (define car (lambda (c) (c (lambda (x y) x))))
              (define cdr (lambda (c) (c (lambda (x y) y))))

              (map cdr (map (lambda (x) (cons x (* x x))) '(1 2 3 4)))
    )V0G0N";
    string test_432 = R"V0G0N(   
                  (define car (lambda x 1))
                (define cdr (lambda x '()))

                (length '(1 2 3 4 5))
    )V0G0N";
    string test_433 = R"V0G0N(   
                  (define cons 'cons)
                  (define null? 'null?)
                  (define pair? 'pair?)

                  (append '(a b) 'c)
    )V0G0N";
    string test_434 = R"V0G0N(   
                  (define number? (lambda x #f))
    )V0G0N";
    string test_435 = R"V0G0N(   
          ;;; fact-x.scm -- Factorial, the painful way...
          ;;; Programmer: Mayer Goldberg, 2014

          (define fact
            (let ((x (lambda (x)
                ((x (lambda (x) (lambda (y) (lambda (z) ((x z) (y z))))))
                  (lambda (x) (lambda (y) x)))))
            (->
            ((lambda (x) (x x))
              (lambda (->)
                (lambda (n)
                  (if (zero? n)
                (lambda (x) (lambda (y) y))
                (let ((z ((-> ->) (- n 1))))
                  (lambda (x)
                    (lambda (y)
                (x ((z x) y)))))))))))
              (lambda (n)
                ((((((((x (x (x (x x)))) (((x (x (x (x x)))) ((x (x (x x))) (x
                (x (x (x x)))))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x x
                ))))) (x (x (x (x x))))))) ((x (x (x x))) (x (x (x x))))) ((((
                (x (x (x (x x)))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x
                (x x)))))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x x)))))
                (x (x (x (x x))))))) ((x (x (x x))) (x (x (x x))))) (((((x (x
                (x (x x)))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x (x x))
                )))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x x))))) (x (x
                (x (x x))))))) ((x (x (x x))) (x (x (x x))))) (((x (x (x (x x)
                ))) (x (x (x x)))) (x (x (x x))))) (((x (x (x(x x)))) (((((x (
                x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (x (x (x x)))
                ) (((x (x (x (x x)))) ((x (x (x x))) (((x(x (x (x x)))) (((x (
                x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (((x (x (x (x
                x)))) ((x (x (x x))) (x (x (x x))))) (x(x (x (x x))))))) ((x (
                x (x x))) (x (x (x x))))))) ((((x (x(x (x x)))) (((x (x (x (x
                x)))) ((x (x (x x))) (x (x (x (x x)))))) (((x (x (x (x x)))) (
                (x (x (x x))) (x (x (x x))))) (x(x (x (x x))))))) ((x (x (x x)
                )) (x (x (x x))))) (((x (x (x (x x)))) (x (x (x x)))) (x (x (x
                x))))))) (((((x (x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))
                ))) (x (x (x x)))) ((x (x(x (x x)))) (((x (x (x (x x)))) ((x (
                x (x x))) (x (x (x (x x)))))) (x (x (x x)))))) (((((x (x (x (x
                x)))) (((x (x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (
                ((x (x (x (x x)))) ((x (x (x x))) (x (x (x x))))) (x (x (x (x
                x))))))) ((x (x (x x))) (x (x (x x))))) (((x (x (x (x x)))) (x
                (x (x x)))) (x (x (x x))))) (x (x (x x))))))) (((x (x (x (x x)
                ))) (((((x (x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (
                x(x (x x)))) (((x(x (x (x x)))) ((x (x (x x))) (x (x (x (x x))
                )))) (x (x (x x))))) (((((x (x (x (x x)))) (((x (x (x (x x))))
                ((x (x (x x)))(x (x (x (x x)))))) (((x (x (x (x x)))) ((x (x (
                x x))) (x (x(x x))))) (x (x (x (x x))))))) ((x (x (x x))) (x (
                x (x x)))))(((x (x (x (x x)))) (x (x (x x)))) (x (x (x x)))))
                (x (x (x x)))))) (((((x (x (x (x x)))) (((x (x (x (x x)))) ((x
                (x (x x)))(x (x (x (x x)))))) (((x (x (x (x x)))) ((x (x (x x)
                )) (x (x(x x))))) (x (x (x (x x))))))) ((x (x (x x))) (x (x (x
                x)))))(((x (x (x (x x)))) (x (x (x x)))) (x (x (x x))))) ((x (
                x (x x))) (((x (x (x (x x)))) (x (x (x x)))) (x (x (x x)))))))
                )))(((((x (x (x (x x)))) ((x (x (x x))) (((x (x (x (x x)))) ((
                (x(x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (((x (x (x
                (x x)))) ((x (x (x x))) (x (x (x x))))) (x (x (x (x x)))))))((
                x (x (x x))) (x (x (x x))))))) ((((x (x (x (x x)))) (((x (x(x
                (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (((x (x (x (x x)))
                )((x (x (x x))) (x (x (x x))))) (x (x (x (x x))))))) ((x(x (x
                x))) (x (x (x x))))) (((x (x (x (x x)))) (x (x (x x))))(x (x (
                x x)))))) (((x (x (x (x x)))) (((x (x (x (x x)))) ((x (x (x x)
                ))(x (x (x (x x)))))) (x (x (x x))))) ((x (x (x x)))(((x (x (x
                (x x)))) (x (x (x x)))) (x (x (x x))))))) (((x (x(x (x x)))) (
                ((x (x (x (x x)))) ((x (x (x x))) (x (x (x (x x)))))) (x (x (x
                x))))) ((x (x (x x))) (((x (x (x (x x)))) (x(x (x x)))) (x (x
                (x x))))))))) ((x (x (x x))) (((x (x (x (x x)))) (x (x (x x)))
                )(x (x (x x))))))
            (-> n))
            (lambda (x) (+ x 1))) 0))))

(fact 5)    
    )V0G0N";
    string test_436 = R"V0G0N(   
           ;;; torture-test-for-compiler-00.scm
          ;;; Testing pvar, bvar, lambda-simple, applic, #f, #t
          ;;; This test should return #t
          ;;;
          ;;; Programmer: Mayer Goldberg, 2010


          (((((lambda (a)
                (lambda (b)
                  (((lambda (a) (lambda (b) ((a b) (lambda (x) (lambda (y) y)))))
              ((lambda (n)
                ((n (lambda (x) (lambda (x) (lambda (y) y))))
                  (lambda (x) (lambda (y) x))))
              (((lambda (a)
                  (lambda (b)
              ((b (lambda (n)
                    ((lambda (p) (p (lambda (a) (lambda (b) b))))
                ((n (lambda (p)
                      (((lambda (a)
                    (lambda (b) (lambda (c) ((c a) b))))
                  ((lambda (n)
                    (lambda (s)
                      (lambda (z) (s ((n s) z)))))
                  ((lambda (p)
                      (p (lambda (a) (lambda (b) a))))
                    p)))
                      ((lambda (p)
                    (p (lambda (a) (lambda (b) a))))
                  p))))
                (((lambda (a)
                    (lambda (b) (lambda (c) ((c a) b))))
                  (lambda (x) (lambda (y) y)))
                  (lambda (x) (lambda (y) y)))))))
                a)))
                a)
                b)))
            ((lambda (n)
                ((n (lambda (x) (lambda (x) (lambda (y) y))))
                (lambda (x) (lambda (y) x))))
              (((lambda (a)
                  (lambda (b)
              ((b (lambda (n)
                    ((lambda (p) (p (lambda (a) (lambda (b) b))))
                    ((n (lambda (p)
                    (((lambda (a)
                  (lambda (b) (lambda (c) ((c a) b))))
                      ((lambda (n)
                    (lambda (s)
                      (lambda (z) (s ((n s) z)))))
                  ((lambda (p)
                    (p (lambda (a) (lambda (b) a))))
                  p)))
                      ((lambda (p)
                  (p (lambda (a) (lambda (b) a))))
                      p))))
                (((lambda (a)
                    (lambda (b) (lambda (c) ((c a) b))))
                  (lambda (x) (lambda (y) y)))
                (lambda (x) (lambda (y) y)))))))
              a)))
                b)
              a)))))
              ((lambda (n)
                ((lambda (p) (p (lambda (a) (lambda (b) b))))
            ((n (lambda (p)
                  (((lambda (a) (lambda (b) (lambda (c) ((c a) b))))
              ((lambda (n) (lambda (s) (lambda (z) (s ((n s) z)))))
              ((lambda (p) (p (lambda (a) (lambda (b) a)))) p)))
                  (((lambda (a)
                (lambda (b)
                  ((b (a (lambda (a)
                      (lambda (b)
                  ((a (lambda (n)
                        (lambda (s)
                    (lambda (z) (s ((n s) z))))))
                  b)))))
                    (lambda (x) (lambda (y) y)))))
              ((lambda (p) (p (lambda (a) (lambda (b) a)))) p))
              ((lambda (p) (p (lambda (a) (lambda (b) b)))) p)))))
            (((lambda (a) (lambda (b) (lambda (c) ((c a) b))))
              (lambda (x) x))
              (lambda (x) x)))))
              (lambda (x) (lambda (y) (x (x (x (x (x y)))))))))
            (((lambda (a)
                (lambda (b)
            ((b (a (lambda (a)
                (lambda (b)
                  ((a (lambda (n)
                  (lambda (s) (lambda (z) (s ((n s) z))))))
                  b)))))
              (lambda (x) (lambda (y) y)))))
              (((lambda (a)
            (lambda (b)
              ((b (a (lambda (a)
                  (lambda (b)
                    ((a (lambda (n)
                    (lambda (s) (lambda (z) (s ((n s) z))))))
                    b)))))
                (lambda (x) (lambda (y) y)))))
                ((lambda (x) (lambda (y) (x (x (x y)))))
            (lambda (x) (lambda (y) (x (x y))))))
                (lambda (x) (lambda (y) (x (x (x y)))))))
              (lambda (x) (lambda (y) (x (x (x (x (x y)))))))))
            #t)
          #f)   
    )V0G0N";
    string test_437 = R"V0G0N(   
            ;;; torture-test-for-compiler-01.scm
            ;;; Tests the tail-call optimization. Assumes zeor?, - and #t
            ;;; The test should return #t
            ;;;
            ;;; Programmer: Mayer Goldberg, 2010

            ((lambda (x) (x x 10000))
            (lambda (x n)
              (if (zero? n) #t
                  (x x (- n 1)))))  
    )V0G0N";
    string test_438 = R"V0G0N(   
          ;;; torture-test-for-compiler-03.scm
        ;;; Testing lambda-opt and lambda-variadic; Should return #t
        ;;;
        ;;; Programmer: Mayer Goldberg, 2010

        (define with (lambda (s f) (apply f s)))

        (define crazy-ack
          (letrec ((ack3
              (lambda (a b c)
                (cond
                ((and (zero? a) (zero? b)) (+ c 1))
                ((and (zero? a) (zero? c)) (ack-x 0 (- b 1) 1))
                ((zero? a) (ack-z 0 (- b 1) (ack-y 0 b (- c 1))))
                ((and (zero? b) (zero? c)) (ack-x (- a 1) 1 0))
                ((zero? b) (ack-z (- a 1) 1 (ack-y a 0 (- c 1))))
                ((zero? c) (ack-x (- a 1) b (ack-y a (- b 1) 1)))
                (else (ack-z (- a 1) b (ack-y a (- b 1) (ack-x a b (- c 1))))))))
            (ack-x
              (lambda (a . bcs)
                (with bcs
            (lambda (b c)
              (ack3 a b c)))))
            (ack-y
              (lambda (a b . cs)
                (with cs
            (lambda (c)
              (ack3 a b c)))))
            (ack-z
              (lambda abcs
                (with abcs
            (lambda (a b c)
              (ack3 a b c))))))
            (lambda ()
              (and (= 7 (ack3 0 2 2))
            (= 61 (ack3 0 3 3))
            (= 316 (ack3 1 1 5))
            (= 636 (ack3 2 0 1))
            ))))

        (crazy-ack)    
    )V0G0N";
    string test_439 = R"V0G0N(   
          ;;; torture-test-for-compiler-005.scm
          ;;; Should return #t
          ;;;
          ;;; Programmer: Mayer Goldberg, 2010

          (((((lambda (x) (x (x x)))
              (lambda (x)
                (lambda (y)
            (x (x y)))))
            (lambda (p)
              (p (lambda (x)
              (lambda (y)
                (lambda (z)
                  ((z y) x)))))))
            (lambda (x)
              ((x #t) #f)))
          (lambda (x)
            (lambda (y)
              x)))    
    )V0G0N";
    string test_440 = R"V0G0N(   
            ;;; torture-test-for-compiler-06.scm
            ;;; << WHAT DOES THIS FILE CONTAIN >>
            ;;;
            ;;; Programmer: Mayer Goldberg, 2012

            (define positive? (lambda (x) (> x 0)))
            
            (define even?
              (letrec ((even-1?
                  (lambda (n)
                    (or (zero? n)
                  (odd-2? (- n 1) 'odd-2))))
                (odd-2?
                  (lambda (n _)
                    (and (positive? n)
                  (even-3? (- n 1) (+ n n) (+ n n n)))))
                (even-3?
                  (lambda (n _1 _2)
                    (or (zero? n)
                  (odd-5? (- n 1) (+ n n) (* n n) 'odd-5 'odder-5))))
                (odd-5?
                  (lambda (n _1 _2 _3 _4)
                    (and (positive? n)
                  (even-1? (- n 1))))))
                even-1?))

            (even? 100) 
    )V0G0N";
    string test_441 = R"V0G0N(   
              ;;; torture-test-for-compiler-006.scm
            ;;; Yet another torture test -- a rather simple one...
            ;;;
            ;;; Programmer: Mayer Goldberg, 2011

            (define test
              (let ((p1 (lambda (x1 x2 x3 x4 x5 x6 x7 x8 x9 x10)
                    (lambda (z)
                (z x2 x3 x4 x5 x6 x7 x8 x9 x10 x1))))
              (s '(a b c d e f g h i j)))
                (lambda ()
                  (equal? (((((((((((apply p1 s) p1) p1) p1) p1) p1) p1) p1) p1) p1)
                    list)
                    s))))
                )V0G0N";
                string test_442 = R"V0G0N(   
                        ;;; torture-test-for-compiler-07.scm
            ;;; << WHAT DOES THIS FILE CONTAIN >>
            ;;;
            ;;; Programmer: Mayer Goldberg, 2013

            (let ((a 1))
              (let ((b 2) (c 3))
                (let ((d 4) (e 5) (f 6))
                  (= 720 (* a b c d e f)))))  
    )V0G0N";
    string test_443 = R"V0G0N(   
          ;;; turture-test-for-compiler-007.scm
        ;;; Testing nested if-expressions
        ;;;
        ;;; Programmer: Mayer Goldberg, 2010
                      
    )V0G0N";
    string test_444 = R"V0G0N(   
              ;;; torture-test-for-compiler-08.scm
              ;;; << WHAT DOES THIS FILE CONTAIN >>
              ;;;
              ;;; Programmer: Mayer Goldberg, 2013

              ;;; should return ((#t) (#t) (#t))

              (let ()
                ((lambda s
                  (let ()
                    ((lambda s s) s s s)))
                #t))
                  )V0G0N";
    string test_445 = R"V0G0N(   
                        ;;; torture-test-for-compiler-008.scm
              ;;; << WHAT DOES THIS FILE CONTAIN >>
              ;;;
              ;;; Programmer: Mayer Goldberg, 2012

              (define with (lambda (s f) (apply f s)))

              (define fact
                (letrec ((fact-1
                    (lambda (n r)
                      (if (zero? n)
                    r
                    (fact-2 (- n 1)
                      (* n r)
                      'moshe
                      'yosi))))
                  (fact-2
                    (lambda (n r _1 _2)
                      (if (zero? n)
                    r
                    (fact-3 (- n 1)
                      (* n r)
                      'dana
                      'michal
                      'olga
                      'sonia))))
                  (fact-3
                    (lambda (n r _1 _2 _3 _4)
                      (if (zero? n)
                    r
                    (fact-1 (- n 1)
                      (* n r))))))
                  (lambda (n)
                    (fact-1 n 1))))   
                  )V0G0N";
    string test_446 = R"V0G0N(   
                          ;;; torture-test-for-compiler-09.scm
              ;;; Testing lambda-opt and apply
              ;;;
              ;;; Programmer: Mayer Goldberg, 2013

              (define with (lambda (s f) (apply f s)))

              (define fact-1
                (lambda (n)
                  (if (zero? n)
                (list 1 'fact-1)
                (with (fact-2 (- n 1))
                  (lambda (r . trail)
                    (cons (* n r)
                      (cons 'fact-1 trail)))))))

              (define fact-2
                (lambda (n)
                  (if (zero? n)
                (list 1 'fact-2)
                (with (fact-3 (- n 1))
                  (lambda (r . trail)
                    (cons (* n r)
                      (cons 'fact-2 trail)))))))

              (define fact-3
                (lambda (n)
                  (if (zero? n)
                (list 1 'fact-3)
                (with (fact-1 (- n 1))
                  (lambda (r . trail)
                    (cons (* n r)
                      (cons 'fact-3 trail)))))))
              (fact-1 10)
              
    )V0G0N";
    string test_447 = R"V0G0N(   
             ;;; torture-test-for-compiler-09.scm
              ;;;
              ;;; Programmer: Mayer Goldberg, 2013

              (let ((x #f))
                (let ()
                  x))

              (let ((x #f) (y #t))
                (let ((x #f))
                  (let ((x #f) (z #f) (t #f))
                    (let ((x #f) (t #f))
                y))))

              ;;; example 0
              ((((lambda (x)
                  (lambda (y)
                    y))
                (lambda (p)
                  (p (lambda (x y)
                  (lambda (p)
                    (p y x))))))
                (lambda (z) (z #t #f)))
              (lambda (x y) x))

              ((((lambda (x)
                  (lambda (y)
                    (x y)))
                (lambda (p)
                  (p (lambda (x y)
                  (lambda (p)
                    (p y x))))))
                (lambda (z) (z #t #f)))
              (lambda (x y) x))

              ;;; example 1
              ((((lambda (x)
                  (lambda (y)
                    (x (x y))))
                (lambda (p)
                  (p (lambda (x y)
                  (lambda (p)
                    (p y x))))))
                (lambda (z) (z #t #f)))
              (lambda (x y) x))

              ;;; example 2
              (((((lambda (x) ((x x) (x x)))
                  (lambda (x)
                    (lambda (y)
                (x (x y)))))
                (lambda (p)
                  (p (lambda (x y)
                  (lambda (p)
                    (p y x))))))
                (lambda (z) (z #t #f)))
              (lambda (x y) x)) 
    )V0G0N";
    
    string test_448 = R"V0G0N(  
        (define andmap (lambda (p lst)
                (or (null? lst)
                    (and (p (car lst)) (andmap p (cdr lst)))) ))
        ; make-matrix creates a matrix (a vector of vectors).
        ; make-matrix creates a matrix (a vector of vectors).
        (define make-matrix
        (lambda (rows columns)
        (letrec ([loop (lambda (m i)
        (if (= i rows)
            (begin m)
            (begin
                (vector-set! m i (make-vector columns))
                (loop m (+ i 1)))))])
        (loop (make-vector rows) 0)))) 
    )V0G0N";
    string test_449 = R"V0G0N( 
            ; matrix? checks to see if its argument is a matrix.
            ; It isn't foolproof, but it's generally good enough.
            (define matrix?
            (lambda (x)
                (and (vector? x)
                    (> (vector-length x) 0)
                    (vector? (vector-ref x 0)))))
    )V0G0N";
    string test_450 = R"V0G0N( 
            ; matrix-rows returns the number of rows in a matrix.
            (define matrix-rows
            (lambda (x)
                (vector-length x)))
    )V0G0N";
    string test_451 = R"V0G0N( 
            ; matrix-columns returns the number of columns in a matrix.
            (define matrix-columns
            (lambda (x)
                (vector-length (vector-ref x 0))))
    )V0G0N";
    string test_452 = R"V0G0N( 
            ; matrix-ref returns the jth element of the ith row.
            (define matrix-ref
            (lambda (m i j)
                (vector-ref (vector-ref m i) j)))
    )V0G0N";
    string test_453 = R"V0G0N( 
            ; matrix-set! changes the jth element of the ith row.
            (define matrix-set!
            (lambda (m i j x)
                (vector-set! (vector-ref m i) j x)))
    )V0G0N";
    string test_454 = R"V0G0N( 
            ; mat-sca-mul multiplies a matrix by a scalar.
            (define mat-sca-mul
            (lambda (x m)
                (let* ([nr (matrix-rows m)]
                    [nc (matrix-columns m)]
                    [r (make-matrix nr nc)])
                    (letrec ([loop (lambda (i)
                    (if (= i nr)
                        (begin r)
                        (begin
                            (letrec ([loop2 (lambda (j)
                            (if (= j nc)
                                #t
                                (begin
                                    (matrix-set! r i j (* x (matrix-ref m i j)))
                                    (loop2 (+ j 1)))))])
            (loop2 0))
                            (loop (+ i 1)))))])
            (loop 0)))))
    )V0G0N";
    string test_455 = R"V0G0N( 
                          (define andmap (lambda (p lst)
                      (or (null? lst)
                          (and (p (car lst)) (andmap p (cdr lst)))) ))
              ; make-matrix creates a matrix (a vector of vectors).
              ; make-matrix creates a matrix (a vector of vectors).
              (define make-matrix
                (lambda (rows columns)
                (letrec ([loop (lambda (m i)
                (if (= i rows)
                    (begin m)
                    (begin
                      (vector-set! m i (make-vector columns))
                      (loop m (+ i 1)))))])
              (loop (make-vector rows) 0)))) 

              ; matrix? checks to see if its argument is a matrix.
              ; It isn't foolproof, but it's generally good enough.
              (define matrix?
                (lambda (x)
                  (and (vector? x)
                      (> (vector-length x) 0)
                      (vector? (vector-ref x 0)))))

              ; matrix-rows returns the number of rows in a matrix.
              (define matrix-rows
                (lambda (x)
                  (vector-length x)))

              ; matrix-columns returns the number of columns in a matrix.
              (define matrix-columns
                (lambda (x)
                  (vector-length (vector-ref x 0))))

              ; matrix-ref returns the jth element of the ith row.
              (define matrix-ref
                (lambda (m i j)
                  (vector-ref (vector-ref m i) j)))

              ; matrix-set! changes the jth element of the ith row.
              (define matrix-set!
                (lambda (m i j x)
                  (vector-set! (vector-ref m i) j x)))

              ; mat-sca-mul multiplies a matrix by a scalar.
              (define mat-sca-mul
                (lambda (x m)
                  (let* ([nr (matrix-rows m)]
                        [nc (matrix-columns m)]
                        [r (make-matrix nr nc)])
                        (letrec ([loop (lambda (i)
                        (if (= i nr)
                            (begin r)
                            (begin
                                (letrec ([loop2 (lambda (j)
                                (if (= j nc)
                                    #t
                                    (begin
                                      (matrix-set! r i j (* x (matrix-ref m i j)))
                                      (loop2 (+ j 1)))))])
                (loop2 0))
                              (loop (+ i 1)))))])
              (loop 0)))))

              ; mat-mat-mul multiplies one matrix by another, after verifying
              ; that the first matrix has as many columns as the second
              ; matrix has rows.
              (define mat-mat-mul
                (lambda (m1 m2)
                  (let* ([nr1 (matrix-rows m1)]
                        [nr2 (matrix-rows m2)]
                        [nc2 (matrix-columns m2)]
                        [r (make-matrix nr1 nc2)])
                        (letrec ([loop (lambda (i)
                        (if (= i nr1)
                            (begin r)
                            (begin
                                (letrec ([loop (lambda (j)
                                (if (= j nc2)
                                    #t
                                    (begin
                                        (letrec ([loop (lambda (k a)
                                        (if (= k nr2)
                                            (begin (matrix-set! r i j a))
                                            (begin
                                              (loop
                                                (+ k 1)
                                                (+ a
                                                  (* (matrix-ref m1 i k)
                                                      (matrix-ref m2 k j)))))))])
                                            (loop 0 0))
                                      (loop (+ j 1)))))])
                                (loop 0))
                        (loop (+ i 1)))))])
              (loop 0))))) 


                ; mul is the generic matrix/scalar multiplication procedure
                (define mul
                  (lambda (x y)
                    (cond
                      [(number? x)
                      (cond
                        [(number? y) (* x y)]
                        [(matrix? y) (mat-sca-mul x y)]
                        [else "this should be an error, but you don't support exceptions"])]
                      [(matrix? x)
                      (cond
                        [(number? y) (mat-sca-mul y x)]
                        [(matrix? y) (mat-mat-mul x y)]
                        [else "this should be an error, but you don't support exceptions"])]
                      [else "this should be an error, but you don't support exceptions"])))


                (mul '#(#(2 3 4)
                #(3 4 5))
              '#(#(1) #(2) #(3)))

              (mul '#(#(1 2 3))
                  '#(#(2 3)
                      #(3 4)
                      #(4 5)))

              (mul '#(#(1 2 3)
                      #(4 5 6))
                  '#(#(1 2 3 4)
                      #(2 3 4 5)
                      #(3 4 5 6)))


              (mul -2
                '#(#(3 -2 -1)
                  #(-3 0 -5)
                  #(7 -1 -1))
                  )


                  (mul 0.5 '#(#(1 2 3)) )
                  (mul 1 0.5)
    )V0G0N";

    // Adding Tests
    /*testsCodes.push_back(test_0);
    testsCodes.push_back(test_1);
    testsCodes.push_back(test_2);
    testsCodes.push_back(test_3);
    testsCodes.push_back(test_4);
    testsCodes.push_back(test_5);
    testsCodes.push_back(test_6);
    testsCodes.push_back(test_7);
    testsCodes.push_back(test_8);
    testsCodes.push_back(test_9);
    testsCodes.push_back(test_10);
    testsCodes.push_back(test_11);
    testsCodes.push_back(test_12);
    testsCodes.push_back(test_13);
    testsCodes.push_back(test_14);
    testsCodes.push_back(test_15);
    testsCodes.push_back(test_16);
    testsCodes.push_back(test_17);
    testsCodes.push_back(test_18);
    testsCodes.push_back(test_19);
    testsCodes.push_back(test_20);
    testsCodes.push_back(test_21);
    testsCodes.push_back(test_22);
    testsCodes.push_back(test_23);
    testsCodes.push_back(test_24);
    testsCodes.push_back(test_25);
    testsCodes.push_back(test_26);*/
    testsCodes.push_back(test_27);
    testsCodes.push_back(test_28);
    testsCodes.push_back(test_29);
    testsCodes.push_back(test_30);
    testsCodes.push_back(test_31);
    testsCodes.push_back(test_32);
    testsCodes.push_back(test_33);
    testsCodes.push_back(test_34);
    testsCodes.push_back(test_35);
    testsCodes.push_back(test_36);
    testsCodes.push_back(test_37);
    testsCodes.push_back(test_38);
    testsCodes.push_back(test_39);
    testsCodes.push_back(test_40);
    testsCodes.push_back(test_41);
    testsCodes.push_back(test_42);
    testsCodes.push_back(test_43);
    testsCodes.push_back(test_44);
    testsCodes.push_back(test_45);
    testsCodes.push_back(test_46);
    testsCodes.push_back(test_47);
    testsCodes.push_back(test_48);
    testsCodes.push_back(test_49);
    testsCodes.push_back(test_50);
    testsCodes.push_back(test_51);
    testsCodes.push_back(test_52);
    testsCodes.push_back(test_53);
    testsCodes.push_back(test_54);
    testsCodes.push_back(test_55);
    testsCodes.push_back(test_56);
    testsCodes.push_back(test_57);
    testsCodes.push_back(test_58);
    testsCodes.push_back(test_59);//
    testsCodes.push_back(test_60);
    testsCodes.push_back(test_61);
    testsCodes.push_back(test_62);
    testsCodes.push_back(test_63);
    testsCodes.push_back(test_64);
    testsCodes.push_back(test_65);
    testsCodes.push_back(test_66);
    testsCodes.push_back(test_67);
    testsCodes.push_back(test_68);
    testsCodes.push_back(test_69);
    testsCodes.push_back(test_70);
    testsCodes.push_back(test_71);
    /*testsCodes.push_back(test_72);
    testsCodes.push_back(test_73);
    testsCodes.push_back(test_74);
    testsCodes.push_back(test_75);
    testsCodes.push_back(test_76);
    testsCodes.push_back(test_77);
    testsCodes.push_back(test_78);
    testsCodes.push_back(test_79);*/
  //  testsCodes.push_back(test_80);
    //testsCodes.push_back(test_81);
    //testsCodes.push_back(test_82);
 /*   testsCodes.push_back(test_83);
    testsCodes.push_back(test_84);
    testsCodes.push_back(test_85);
    testsCodes.push_back(test_86);
    testsCodes.push_back(test_87);
    testsCodes.push_back(test_88);
    testsCodes.push_back(test_89);
    testsCodes.push_back(test_90);
    testsCodes.push_back(test_91);
    testsCodes.push_back(test_92);
    testsCodes.push_back(test_93);
    testsCodes.push_back(test_94);
    testsCodes.push_back(test_95);
    testsCodes.push_back(test_96);
    testsCodes.push_back(test_97);
    testsCodes.push_back(test_98);
    testsCodes.push_back(test_99);
    testsCodes.push_back(test_100);
    testsCodes.push_back(test_101);
    testsCodes.push_back(test_102);
    testsCodes.push_back(test_103);
    testsCodes.push_back(test_104);
    testsCodes.push_back(test_105);
    testsCodes.push_back(test_106);
    testsCodes.push_back(test_107);
    testsCodes.push_back(test_108);
    testsCodes.push_back(test_109);
    testsCodes.push_back(test_110);
    testsCodes.push_back(test_111);
    testsCodes.push_back(test_112);
    testsCodes.push_back(test_113);
    testsCodes.push_back(test_114);
    testsCodes.push_back(test_115);
    testsCodes.push_back(test_116);
    testsCodes.push_back(test_117);
    testsCodes.push_back(test_118);
    testsCodes.push_back(test_119);
    testsCodes.push_back(test_120);
    testsCodes.push_back(test_121);
    testsCodes.push_back(test_122);
    testsCodes.push_back(test_123);
    testsCodes.push_back(test_124);
    testsCodes.push_back(test_125);
    testsCodes.push_back(test_126);
    testsCodes.push_back(test_127);
    testsCodes.push_back(test_128);
    testsCodes.push_back(test_129);
    testsCodes.push_back(test_130);
    testsCodes.push_back(test_131);
    testsCodes.push_back(test_132);
    testsCodes.push_back(test_133);
    testsCodes.push_back(test_134);
    testsCodes.push_back(test_135);
    testsCodes.push_back(test_136);
    testsCodes.push_back(test_137);
    testsCodes.push_back(test_138);
    testsCodes.push_back(test_139);
    testsCodes.push_back(test_140);
    testsCodes.push_back(test_141);
    testsCodes.push_back(test_142);
    testsCodes.push_back(test_143);
    testsCodes.push_back(test_144);
    testsCodes.push_back(test_145);
    testsCodes.push_back(test_146);
    testsCodes.push_back(test_147);
    testsCodes.push_back(test_148);
    testsCodes.push_back(test_149);
    testsCodes.push_back(test_150);
    testsCodes.push_back(test_151);
    testsCodes.push_back(test_152);
   // testsCodes.push_back(test_153);
    testsCodes.push_back(test_154);
   // testsCodes.push_back(test_155);*/
    testsCodes.push_back(test_156);
    testsCodes.push_back(test_157);
    testsCodes.push_back(test_158);
    testsCodes.push_back(test_159);
    testsCodes.push_back(test_160);
    testsCodes.push_back(test_161);
    testsCodes.push_back(test_162);
    testsCodes.push_back(test_163);
    testsCodes.push_back(test_164);
    testsCodes.push_back(test_165);
    testsCodes.push_back(test_166);
    testsCodes.push_back(test_167);
    testsCodes.push_back(test_168);
    testsCodes.push_back(test_169);
    testsCodes.push_back(test_170);
    testsCodes.push_back(test_171);
    testsCodes.push_back(test_172);
    testsCodes.push_back(test_173);
    testsCodes.push_back(test_174);
    testsCodes.push_back(test_175);
    //testsCodes.push_back(test_176);
    testsCodes.push_back(test_177);
    testsCodes.push_back(test_178);
    testsCodes.push_back(test_179);
    testsCodes.push_back(test_180);
    testsCodes.push_back(test_181);
    testsCodes.push_back(test_182);
    testsCodes.push_back(test_183);
    testsCodes.push_back(test_184);
    testsCodes.push_back(test_185);
    testsCodes.push_back(test_186);
    testsCodes.push_back(test_187);
    testsCodes.push_back(test_188);
    testsCodes.push_back(test_189);
    testsCodes.push_back(test_190);
    testsCodes.push_back(test_191);
    testsCodes.push_back(test_192);
    testsCodes.push_back(test_193);
    testsCodes.push_back(test_194);
    testsCodes.push_back(test_195);
    testsCodes.push_back(test_196);
    testsCodes.push_back(test_197);
    testsCodes.push_back(test_198);
    testsCodes.push_back(test_199);
    testsCodes.push_back(test_200);
    testsCodes.push_back(test_201);
    testsCodes.push_back(test_202);
    testsCodes.push_back(test_203);
    testsCodes.push_back(test_204);
    testsCodes.push_back(test_205);
    testsCodes.push_back(test_206);
    testsCodes.push_back(test_207);
    testsCodes.push_back(test_208);
    testsCodes.push_back(test_209);
    testsCodes.push_back(test_210);
    testsCodes.push_back(test_211);
    testsCodes.push_back(test_212);
    testsCodes.push_back(test_213);
    testsCodes.push_back(test_214);
    testsCodes.push_back(test_215);
    testsCodes.push_back(test_216);
    testsCodes.push_back(test_217);
    testsCodes.push_back(test_218);
    /*testsCodes.push_back(test_219);
    testsCodes.push_back(test_220);
    testsCodes.push_back(test_221);
    testsCodes.push_back(test_222);
    testsCodes.push_back(test_223);
    testsCodes.push_back(test_224);
    testsCodes.push_back(test_225);
    testsCodes.push_back(test_226);
    testsCodes.push_back(test_227);
    testsCodes.push_back(test_228);
    testsCodes.push_back(test_229);
    testsCodes.push_back(test_230);
    testsCodes.push_back(test_231);
    testsCodes.push_back(test_232);
    testsCodes.push_back(test_233);
    testsCodes.push_back(test_234);
    testsCodes.push_back(test_235);
    testsCodes.push_back(test_236);
    testsCodes.push_back(test_237);
    testsCodes.push_back(test_238);
    testsCodes.push_back(test_239);*/
    testsCodes.push_back(test_240);
   /* testsCodes.push_back(test_241);
    testsCodes.push_back(test_242);
    testsCodes.push_back(test_243);
    testsCodes.push_back(test_244);
    testsCodes.push_back(test_245);
    testsCodes.push_back(test_246);
    testsCodes.push_back(test_247);
    testsCodes.push_back(test_248);
    testsCodes.push_back(test_249);
    testsCodes.push_back(test_250);
    testsCodes.push_back(test_251);
    testsCodes.push_back(test_252);
    testsCodes.push_back(test_253);
    testsCodes.push_back(test_254);
    testsCodes.push_back(test_255);
    testsCodes.push_back(test_256);
    testsCodes.push_back(test_257);
    testsCodes.push_back(test_258);
    testsCodes.push_back(test_259);
    testsCodes.push_back(test_260);
    testsCodes.push_back(test_261);
    testsCodes.push_back(test_262);
    testsCodes.push_back(test_263);
    testsCodes.push_back(test_264);
    testsCodes.push_back(test_265);
    testsCodes.push_back(test_266);
    testsCodes.push_back(test_267);
    testsCodes.push_back(test_268);
    testsCodes.push_back(test_269);
    testsCodes.push_back(test_270);
    testsCodes.push_back(test_271);
    testsCodes.push_back(test_272);
    testsCodes.push_back(test_273);
    testsCodes.push_back(test_274);
    testsCodes.push_back(test_275);
    testsCodes.push_back(test_276);
    testsCodes.push_back(test_277);
    testsCodes.push_back(test_278);
    testsCodes.push_back(test_279);
    testsCodes.push_back(test_280);
    testsCodes.push_back(test_281);
    testsCodes.push_back(test_282);
    testsCodes.push_back(test_283);
    testsCodes.push_back(test_284);
    testsCodes.push_back(test_285);
    testsCodes.push_back(test_286);
    testsCodes.push_back(test_287);
    testsCodes.push_back(test_288);
    testsCodes.push_back(test_289);
    testsCodes.push_back(test_290);
    testsCodes.push_back(test_291);
    testsCodes.push_back(test_292);
    testsCodes.push_back(test_293);
    testsCodes.push_back(test_294);
    testsCodes.push_back(test_295);
    testsCodes.push_back(test_296);
    testsCodes.push_back(test_297);
    testsCodes.push_back(test_298);
    testsCodes.push_back(test_299);
    testsCodes.push_back(test_300);
    testsCodes.push_back(test_301);
    testsCodes.push_back(test_302);
    testsCodes.push_back(test_303);
    testsCodes.push_back(test_304);
    testsCodes.push_back(test_305);
    testsCodes.push_back(test_306);
    testsCodes.push_back(test_307);
    testsCodes.push_back(test_308);
    testsCodes.push_back(test_309);
    testsCodes.push_back(test_310);
    testsCodes.push_back(test_311);
    testsCodes.push_back(test_312);
    testsCodes.push_back(test_313);
    testsCodes.push_back(test_314);
    testsCodes.push_back(test_315);
    testsCodes.push_back(test_316);
    testsCodes.push_back(test_317);
    testsCodes.push_back(test_318);
    testsCodes.push_back(test_319);
    testsCodes.push_back(test_320);
    testsCodes.push_back(test_321);
    testsCodes.push_back(test_322);
    testsCodes.push_back(test_323);
    testsCodes.push_back(test_324);
    testsCodes.push_back(test_325);
    testsCodes.push_back(test_326);
    testsCodes.push_back(test_327);
    testsCodes.push_back(test_328);
    testsCodes.push_back(test_329);
    testsCodes.push_back(test_330);
    testsCodes.push_back(test_331);
    testsCodes.push_back(test_332);
    testsCodes.push_back(test_333);
    testsCodes.push_back(test_334);
    testsCodes.push_back(test_335);
    testsCodes.push_back(test_336);
    testsCodes.push_back(test_337);
    testsCodes.push_back(test_338);
    testsCodes.push_back(test_339);
    testsCodes.push_back(test_340);
    testsCodes.push_back(test_341);
    testsCodes.push_back(test_342);
    testsCodes.push_back(test_343);
    testsCodes.push_back(test_344);
    testsCodes.push_back(test_345);
    testsCodes.push_back(test_346);
    testsCodes.push_back(test_347);
    testsCodes.push_back(test_348);
    testsCodes.push_back(test_349);
    testsCodes.push_back(test_350);
    testsCodes.push_back(test_351);
    testsCodes.push_back(test_352);
    testsCodes.push_back(test_353);
    testsCodes.push_back(test_354);
    testsCodes.push_back(test_355);
    testsCodes.push_back(test_356);
    testsCodes.push_back(test_357);
    testsCodes.push_back(test_358);
    testsCodes.push_back(test_359);
    testsCodes.push_back(test_360);
    testsCodes.push_back(test_361);
    testsCodes.push_back(test_362);
    testsCodes.push_back(test_363);
    testsCodes.push_back(test_364);
    testsCodes.push_back(test_365);
    testsCodes.push_back(test_366);
    testsCodes.push_back(test_367);
    testsCodes.push_back(test_368);
    testsCodes.push_back(test_369);
    testsCodes.push_back(test_370);
    testsCodes.push_back(test_371);
    testsCodes.push_back(test_372);
    testsCodes.push_back(test_373);
    testsCodes.push_back(test_374);
    testsCodes.push_back(test_375);
    testsCodes.push_back(test_376);
    testsCodes.push_back(test_377);
    testsCodes.push_back(test_378);
    testsCodes.push_back(test_379);
    testsCodes.push_back(test_380);
    testsCodes.push_back(test_381);
    testsCodes.push_back(test_382);
    testsCodes.push_back(test_383);
    testsCodes.push_back(test_384);
    testsCodes.push_back(test_385);
    testsCodes.push_back(test_386);
    testsCodes.push_back(test_387);
    testsCodes.push_back(test_388);
    testsCodes.push_back(test_389);
    testsCodes.push_back(test_390);
    testsCodes.push_back(test_391);
    testsCodes.push_back(test_392);
    testsCodes.push_back(test_393);
    testsCodes.push_back(test_394);
    testsCodes.push_back(test_395);
    testsCodes.push_back(test_396);
    testsCodes.push_back(test_397);
    testsCodes.push_back(test_398);
    testsCodes.push_back(test_399);
    testsCodes.push_back(test_400);
    testsCodes.push_back(test_401);
    testsCodes.push_back(test_402);
    testsCodes.push_back(test_403);
    testsCodes.push_back(test_404);
    testsCodes.push_back(test_405);
    testsCodes.push_back(test_406);
    testsCodes.push_back(test_407);
    testsCodes.push_back(test_408);
    testsCodes.push_back(test_409);
    testsCodes.push_back(test_410);
    testsCodes.push_back(test_411);
    testsCodes.push_back(test_412);
    testsCodes.push_back(test_413);
    testsCodes.push_back(test_414);
    testsCodes.push_back(test_415);
    testsCodes.push_back(test_416);
    testsCodes.push_back(test_417);
    testsCodes.push_back(test_418);
    testsCodes.push_back(test_419);
    testsCodes.push_back(test_420);
    testsCodes.push_back(test_421);
    testsCodes.push_back(test_422);
    testsCodes.push_back(test_423);
    testsCodes.push_back(test_424);
    testsCodes.push_back(test_425);
    testsCodes.push_back(test_426);
    testsCodes.push_back(test_427);
    testsCodes.push_back(test_428);
    testsCodes.push_back(test_429);
    testsCodes.push_back(test_430);
    testsCodes.push_back(test_431);
    testsCodes.push_back(test_432);
    testsCodes.push_back(test_433);
    testsCodes.push_back(test_434);
    testsCodes.push_back(test_435);
    testsCodes.push_back(test_436);
    testsCodes.push_back(test_437);
    testsCodes.push_back(test_438);
    testsCodes.push_back(test_439);
    testsCodes.push_back(test_440);
    testsCodes.push_back(test_441);
    testsCodes.push_back(test_442);
    testsCodes.push_back(test_443);
    testsCodes.push_back(test_444);
    testsCodes.push_back(test_445);
    testsCodes.push_back(test_446);
    testsCodes.push_back(test_447);
    testsCodes.push_back(test_448);
    testsCodes.push_back(test_449);
    testsCodes.push_back(test_450);
    testsCodes.push_back(test_451);
    testsCodes.push_back(test_452);
    testsCodes.push_back(test_453);
    testsCodes.push_back(test_454);
    testsCodes.push_back(test_455);*/
}

/* ### Example of use ###

// Executing DEMO_TEST
void DEMO_TEST()
{
  // Initializing
  currentTestName = DEMO_TEST

  // Testing

  test(0,"got","expected");

  try
  {
    test(1,"maybe exception will be thrwon from here,"$$$ ASSERT_THROWN_EXCEPTIONS $$$");
  }
  catch (ExceptionType exp)
  {
    test("","$$$ DECLARE GOOD TEST $$$");
  }

}
*/

// Processing test
bool procceseTest(string testName,unsigned int testNumber){
    // Initializing 
    string testBaseFolder = "Tests/" + testName;
    string testFolder = "./Project_Test/" + testBaseFolder;
    string testFile = testFolder + "/test";
    string testAssemblyFile = testFile + ".s";
    string testAssemblyFileMacroExpanded = testFile + "_MACRO_EXPANDED.s";
    string testFileForDebugDotO = testFile + "_FOR_DEBUG.o";
    string testFileForDebug = testFile + "_FOR_DEBUG";

    // Creating Program Interpretation And Compilation Execution Commands
    string cleanCommand = "cd ../ && rm test";
    string makeCommand = "cd ../ && make -f ./Makefile " + testFile + " > " + 
                          testFolder + "/makeOutput.txt";
    string macro_expandCommand = "cd ../ && nasm -f elf64 -e -o " + testAssemblyFileMacroExpanded + " " + testAssemblyFile;
    string for_DebugCommand = "cd ../ && nasm -f elf64 -g -o " + testFileForDebugDotO + " " + testAssemblyFile + 
                              " && gcc -ggdb -static -m64 -o " + testFileForDebug + " " + testFileForDebugDotO;
    string schemeCommand = "cd ../ && scheme -q < " + testFile + ".scm";
    string studentCommand = "cd ../ && ./test";
    
    // Executing Interpretation And Compilation Execution Commands
    string got_cleanCommand = GetStdoutFromCommand(cleanCommand);
    string got_makeCommand = GetStdoutFromCommand(makeCommand);
    string got_macro_expandCommand = GetStdoutFromCommand(macro_expandCommand);
    string got_for_DebugCommand = GetStdoutFromCommand(for_DebugCommand);
    string got_schemeCommand = GetStdoutFromCommand(schemeCommand);
    string got_studentCommand = GetStdoutFromCommand(studentCommand);

    // Creating Test File 
    string testCreateString = "(equal? \n\n ;Scheme Output:\n'(\n\n" + got_schemeCommand + "\n\n) \n\n\n\n\n\n;Yours Output:\n'(\n\n" + 
                                got_studentCommand + "\n\n)\n\n\n\n)";
    std::ofstream out(testBaseFolder + "/" + "testPassCheck.scm");
    out << testCreateString;
    out.close();                           

    // Creating Program Test Commands
    string testCommand = "cd ../ && scheme -q < " + testFolder + "/" + "testPassCheck.scm";

    // Executing Program Test Commands
    string got_testCommand = GetStdoutFromCommand(testCommand);

    test(testNumber,got_testCommand,"#t\n",vector<string>{"String value with /n"});

    return 0;
}

// Creating Tests
unsigned int CreateTests()
{
  // Creating Tests Folder
  string createTestFolderCommand = "rm -rf Tests && mkdir Tests";
  string got_createTestFolder = GetStdoutFromCommand(createTestFolderCommand);

   // Creating Tests
  for(unsigned int i = 0;i < testsCodes.size();i++)
  { 
    // Retrieving current test to create
    string currentTest = testsCodes.at(i);

    // Defining Test Folder
    string testFolder = "./Tests/test_" + std::to_string(i);
    string testFile = testFolder + "/" + "test" + ".scm";

    // Creating Current Test Files
    string createTestsFilesCommand = "mkdir " + testFolder + " && touch " + testFile;
    string got_createTestsFilesCommand  = GetStdoutFromCommand(createTestsFilesCommand );

    // Creating Test Code
    std::ofstream out(testFile);
    out << currentTest;
    out.close();
  }

  return testsCodes.size();
}

void sigintHandler(int num){
    abortExecution = 1;
}

// Executing FINAL_PROJECT_TEST
void FINAL_PROJECT_TEST()
{
  // Initializing
  currentTestName = "FINAL_PROJECT_TEST";
  char arr[100];
  memset(arr,' ',100);
  arr[100] = 0;
  int progress_index = 0;
  int progress;
  const char* no_error_progress = "\e[38;5;082m[%s]\e[38;5;226m%i%% %d/%d\r\e[0m";
  const char* yes_error_progress = "\e[38;5;082m[%s]\e[38;5;196m%i%% %d/%d\r\e[0m";

  // Creating Tests
  unsigned int numberOfTests = CreateTests();

  // Printing initial progress
  printf(no_error_progress,arr,0,0,numberOfTests);
  fflush(stdout);

  // Testing
  for(unsigned int i = 0;i < numberOfTests;i++)
  {  
    // Updating progress 
    if(progress > progress_index)
    { 
      progress_index += 1;
      arr[progress_index] = '#';
    }

    // Testing
    if(abortExecution == 0){
      procceseTest("test_" + std::to_string(i),i);
    }
    else{
      // Declaring test was aborted
      cout << RED << std::endl << "Final Project Test Was Aborted With " << i << " Tests Executed Out Of " << numberOfTests << " !!!" << RESET << std::endl;
      red = red + (numberOfTests - i);
      break;
    }

    float float_index = (float)i;
    progress = (float_index/numberOfTests) * 100;
    if(red == 0){
      printf(no_error_progress,arr,progress,i+1,numberOfTests);
    }
    else{
      printf(yes_error_progress,arr,progress,i+1,numberOfTests);
    }
    fflush(stdout);
  }
  
  // Cleaning after progress bar
  printf("%%\r                                                                                                                                    \n");
}



