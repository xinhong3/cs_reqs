%%%%% for unsupported requirements, we put 'unsupported' and assume they are satisfied.
unsupported_prereq.     %%% assume unsupported prereqs are satisfied
unsupported_coreq.      %%% assume unsupported coreqs are satisfied
course("CSE 101", 4).
has_prereq("CSE 101").
prereq("CSE 101", Sem) :- semester(Sem),unsupported_prereq.
has_anti_req("CSE 101").
anti_req("CSE 101", Sem) :- semester(Sem),unsupported_anti_req.
course("CSE 102", 3).
has_advisory_prereq("CSE 102").
advisory_prereq("CSE 102", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("CSE 110", 3).
has_prereq("CSE 110").
prereq("CSE 110", Sem) :- semester(Sem),unsupported_prereq.
course("CSE 113", 4).
has_prereq("CSE 113").
prereq("CSE 113", Sem) :- semester(Sem),unsupported_prereq.
course("CSE 114", 4).
has_prereq("CSE 114").
prereq("CSE 114", Sem) :- semester(Sem),unsupported_prereq.
has_advisory_prereq("CSE 114").
advisory_prereq("CSE 114", Sem) :- semester(Sem),taken_before(("CSE 101"; "ISE 108"), Sem).
course("CSE 130", 3).
has_prereq("CSE 130").
prereq("CSE 130", Sem) :- semester(Sem),unsupported_prereq.
course("CSE 150", 4).
has_prereq("CSE 150").
prereq("CSE 150", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("CSE 160", 3).
has_prereq("CSE 160").
prereq("CSE 160", Sem) :- semester(Sem),unsupported_prereq.
has_advisory_prereq("CSE 160").
advisory_prereq("CSE 160", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("CSE 161", 1).
has_coreq("CSE 161").
coreq("CSE 161", Sem) :- semester(Sem),taken_same("CSE 160", Sem).
course("CSE 190", 3).
course("CSE 191", 3).
course("CSE 192", 3).
course("CSE 214", 4).
has_prereq("CSE 214").
prereq("CSE 214", Sem) :- semester(Sem),passed_before(("CSE 114","C"), Sem).
course("CSE 215", 4).
has_prereq("CSE 215").
prereq("CSE 215", Sem) :- semester(Sem),taken_before(("AMS 151"; "MAT 125"; "MAT 131"), Sem).
course("CSE 216", 4).
has_prereq("CSE 216").
prereq("CSE 216", Sem) :- semester(Sem),passed_before(("CSE 214","C"), Sem),major("CSE").
course("CSE 220", 4).
has_prereq("CSE 220").
prereq("CSE 220", Sem) :- semester(Sem),unsupported_prereq.
course("CSE 230", 3).
has_prereq("CSE 230").
prereq("CSE 230", Sem) :- semester(Sem),taken_before(("CSE 130"; "CSE 220"; "ESE 124"; "ESG 111"; "BME 120"; "MEC 102"), Sem).
course("CSE 260", 3).
has_prereq("CSE 260").
prereq("CSE 260", Sem) :- semester(Sem),taken_before("CSE 160", Sem).
has_coreq("CSE 260").
coreq("CSE 260", Sem) :- semester(Sem),taken_same("CSE 261", Sem).
course("CSE 261", 1).
has_coreq("CSE 261").
coreq("CSE 261", Sem) :- semester(Sem),taken_same("CSE 260", Sem).
course("CSE 300", 3).
has_prereq("CSE 300").
prereq("CSE 300", Sem) :- semester(Sem),taken_before("WRT 102", Sem),major("CSE"; "ISE"; "DAS"),standing("U3"; "U4").
course("CSE 301", 3).
has_prereq("CSE 301").
prereq("CSE 301", Sem) :- semester(Sem),standing("U2"; "U3"; "U4").
has_advisory_prereq("CSE 301").
advisory_prereq("CSE 301", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("CSE 303", 3).
has_prereq("CSE 303").
prereq("CSE 303", Sem) :- semester(Sem),passed_before(("CSE 160","C"; "CSE 214","C"), Sem),passed_before(("CSE 150","C"; "CSE 215","C"), Sem),major("CSE").
course("CSE 304", 3).
has_prereq("CSE 304").
prereq("CSE 304", Sem) :- semester(Sem),passed_before(("CSE 216","C"; "CSE 260","C"), Sem),passed_before(("CSE 220","C"), Sem).
has_advisory_prereq("CSE 304").
advisory_prereq("CSE 304", Sem) :- semester(Sem),taken_before(("CSE 303"; "CSE 350"), Sem).
course("CSE 305", 3).
has_prereq("CSE 305").
prereq("CSE 305", Sem) :- semester(Sem),passed_before(("CSE 214","C"), Sem),passed_before(("CSE 216","C"; "CSE 260","C"), Sem),major("CSE"; "DAS").
course("CSE 306", 3).
has_prereq("CSE 306").
prereq("CSE 306", Sem) :- semester(Sem),passed_before(("CSE 320","C"; "ESE 280","C"), Sem),major("CSE"; "ECE").
course("CSE 307", 3).
has_prereq("CSE 307").
prereq("CSE 307", Sem) :- semester(Sem),passed_before(("CSE 214","C"), Sem),passed_before(("CSE 216","C"; "CSE 260","C"), Sem),major("CSE"; "DAS").
course("CSE 310", 3).
has_prereq("CSE 310").
prereq("CSE 310", Sem) :- semester(Sem),passed_before(("CSE 214","C"; "CSE 260","C"), Sem),passed_before(("CSE 220","C"; "ISE 218","C"), Sem),major("CSE"; "ISE").
course("CSE 311", 3).
has_prereq("CSE 311").
prereq("CSE 311", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 230"; "CSE 260"; "ISE 208"), Sem),major("ISE"; "CSE").
course("CSE 312", 3).
has_prereq("CSE 312").
prereq("CSE 312", Sem) :- semester(Sem),major("CSE"; "ISE"; "DAS"),standing("U3"; "U4"),unsupported_prereq.
course("CSE 316", 3).
has_prereq("CSE 316").
prereq("CSE 316", Sem) :- semester(Sem),passed_before(("CSE 214","C"; "CSE 260","C"), Sem),passed_before(("CSE 216","C"; "CSE 307","C"), Sem),major("CSE").
course("CSE 320", 3).
has_prereq("CSE 320").
prereq("CSE 320", Sem) :- semester(Sem),unsupported_prereq.
course("CSE 323", 3).
has_prereq("CSE 323").
prereq("CSE 323", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 230"; "CSE 260"; "ISE 208"), Sem).
course("CSE 325", 3).
has_prereq("CSE 325").
prereq("CSE 325", Sem) :- semester(Sem),taken_before(("CSE 110"; "CSE 101"; "CSE 114"), Sem).
course("CSE 327", 3).
has_prereq("CSE 327").
prereq("CSE 327", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 230"; "CSE 260"), Sem),taken_before(("AMS 210"; "MAT 211"), Sem),major("CSE"; "ISE"; "DAS").
course("CSE 328", 3).
has_prereq("CSE 328").
prereq("CSE 328", Sem) :- semester(Sem),passed_before(("CSE 220","C"), Sem),major("CSE"; "DAS").
course("CSE 331", 3).
has_prereq("CSE 331").
prereq("CSE 331", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
has_advisory_pre_or_coreq("CSE 331").
advisory_pre_or_coreq("CSE 331", Sem) :- semester(Sem),taken_before("CSE 320", Sem).
course("CSE 332", 3).
has_prereq("CSE 332").
prereq("CSE 332", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),taken_before(("MAT 211"; "AMS 210"), Sem),taken_before(("AMS 110"; "AMS 310"), Sem),major("CSE"; "ISE"; "DAS").
course("CSE 333", 3).
has_prereq("CSE 333").
prereq("CSE 333", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 334", 3).
has_prereq("CSE 334").
prereq("CSE 334", Sem) :- semester(Sem),standing("U2"; "U3"; "U4"),major("CSE"; "ISE").
course("CSE 336", 3).
has_prereq("CSE 336").
prereq("CSE 336", Sem) :- semester(Sem),passed_before(("CSE 214","C"; "CSE 260","C"), Sem),major("CSE").
course("CSE 337", 3).
has_prereq("CSE 337").
prereq("CSE 337", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE"; "DAS"),standing("U3"; "U4").
course("CSE 350", 4).
has_prereq("CSE 350").
prereq("CSE 350", Sem) :- semester(Sem),taken_before(("CSE 113"; "CSE 150"; "CSE 215"), Sem),taken_before(("AMS 210"; "MAT 211"), Sem),unsupported_prereq.
course("CSE 351", 3).
has_prereq("CSE 351").
prereq("CSE 351", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),taken_before("AMS 310", Sem),major("CSE"; "DAS").
course("CSE 352", 3).
has_prereq("CSE 352").
prereq("CSE 352", Sem) :- semester(Sem),taken_before(("CSE 316"; "CSE 351"), Sem),major("CSE"; "DAS").
course("CSE 353", 3).
has_prereq("CSE 353").
prereq("CSE 353", Sem) :- semester(Sem),taken_before(("CSE 316"; "CSE 351"), Sem),major("CSE"; "DAS").
has_pre_or_coreq("CSE 353").
pre_or_coreq("CSE 353", Sem) :- semester(Sem),taken_before(("AMS 310"; "AMS 311"; "AMS 412"), Sem).
course("CSE 354", 3).
has_prereq("CSE 354").
prereq("CSE 354", Sem) :- semester(Sem),taken_before(("CSE 316"; "CSE 351"), Sem),major("CSE"; "DAS").
course("CSE 355", 3).
has_prereq("CSE 355").
prereq("CSE 355", Sem) :- semester(Sem),taken_before("AMS 301", Sem),unsupported_prereq.
course("CSE 356", 3).
has_prereq("CSE 356").
prereq("CSE 356", Sem) :- semester(Sem),passed_before(("CSE 316","C"), Sem),passed_before(("CSE 320","C"), Sem),major("CSE").
course("CSE 357", 3).
has_prereq("CSE 357").
prereq("CSE 357", Sem) :- semester(Sem),passed_before(("CSE 316","C"; "CSE 351","C"), Sem),passed_before(("AMS 310","C"), Sem),major("CSE"; "DAS").
course("CSE 360", 3).
has_prereq("CSE 360").
prereq("CSE 360", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
has_advisory_pre_or_coreq("CSE 360").
advisory_pre_or_coreq("CSE 360", Sem) :- semester(Sem),taken_before("CSE 320", Sem).
course("CSE 361", 3).
has_prereq("CSE 361").
prereq("CSE 361", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
has_advisory_pre_or_coreq("CSE 361").
advisory_pre_or_coreq("CSE 361", Sem) :- semester(Sem),taken_before("CSE 320", Sem).
course("CSE 362", 3).
has_prereq("CSE 362").
prereq("CSE 362", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
has_advisory_pre_or_coreq("CSE 362").
advisory_pre_or_coreq("CSE 362", Sem) :- semester(Sem),taken_before("CSE 320", Sem).
course("CSE 363", 3).
has_prereq("CSE 363").
prereq("CSE 363", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
has_advisory_pre_or_coreq("CSE 363").
advisory_pre_or_coreq("CSE 363", Sem) :- semester(Sem),taken_before("CSE 320", Sem).
course("CSE 364", 3).
has_prereq("CSE 364").
prereq("CSE 364", Sem) :- semester(Sem),taken_before(("CSE 334"; "ISE 334"), Sem).
course("CSE 366", 3).
has_prereq("CSE 366").
prereq("CSE 366", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),taken_before(("MAT 211"; "AMS 210"), Sem),major("CSE"; "ISE").
course("CSE 370", 3).
has_prereq("CSE 370").
prereq("CSE 370", Sem) :- semester(Sem),taken_before("CSE 310", Sem),major("CSE").
course("CSE 371", 3).
has_prereq("CSE 371").
prereq("CSE 371", Sem) :- semester(Sem),taken_before(("CSE 113"; "CSE 150"; "CSE 215"; "MAT 200"; "MAT 250"), Sem).
course("CSE 373", 3).
has_prereq("CSE 373").
prereq("CSE 373", Sem) :- semester(Sem),passed_before(("CSE 113","C"; "CSE 150","C"; "CSE 215","C"; "MAT 200","C"; "MAT 250","C"), Sem),passed_before(("MAT 211","C"; "AMS 210","C"), Sem),passed_before(("CSE 214","C"; "CSE 260","C"), Sem),major("CSE"; "MAT"; "DAS").
course("CSE 376", 3).
has_prereq("CSE 376").
prereq("CSE 376", Sem) :- semester(Sem),passed_before(("CSE 320","C"), Sem),major("CSE").
course("CSE 377", 3).
has_prereq("CSE 377").
prereq("CSE 377", Sem) :- semester(Sem),taken_before(("AMS 161"; "MAT 127"; "MAT 132"), Sem),taken_before(("AMS 210"; "MAT 211"), Sem).
course("CSE 378", 3).
has_prereq("CSE 378").
prereq("CSE 378", Sem) :- semester(Sem),taken_before(("AMS 161"; "MAT 127"; "MAT 132"), Sem),taken_before(("AMS 210"; "MAT 211"; "MEC 262"), Sem).
course("CSE 380", 3).
has_prereq("CSE 380").
prereq("CSE 380", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
course("CSE 381", 3).
has_prereq("CSE 381").
prereq("CSE 381", Sem) :- semester(Sem),taken_before("CSE 220", Sem),major("CSE").
course("CSE 385", 4).
has_prereq("CSE 385").
prereq("CSE 385", Sem) :- semester(Sem),taken_before(("CSE 113"; "CSE 150"; "CSE 215"; "MAT 200"; "MAT 250"), Sem),taken_before(("AMS 210"; "MAT 211"), Sem),taken_before(("CSE 214"; "CSE 260"), Sem),unsupported_prereq.
course("CSE 390", 3).
has_prereq("CSE 390").
prereq("CSE 390", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 391", 3).
has_prereq("CSE 391").
prereq("CSE 391", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 392", 3).
has_prereq("CSE 392").
prereq("CSE 392", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 393", 3).
has_prereq("CSE 393").
prereq("CSE 393", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 394", 3).
has_prereq("CSE 394").
prereq("CSE 394", Sem) :- semester(Sem),taken_before(("CSE 214"; "CSE 260"), Sem),major("CSE"; "ISE").
course("CSE 416", 3).
has_prereq("CSE 416").
prereq("CSE 416", Sem) :- semester(Sem),passed_before(("CSE 316","C"), Sem),standing("U4"),major("CSE").
course("CSE 475", 3).
has_prereq("CSE 475").
prereq("CSE 475", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
has_prereq("CSE 487").
prereq("CSE 487", Sem) :- semester(Sem),permission.
course("CSE 488", 3).
has_prereq("CSE 488").
prereq("CSE 488", Sem) :- semester(Sem),major("CSE"),standing("U3"; "U4"),permission.
course("CSE 495", 3).
has_prereq("CSE 495").
prereq("CSE 495", Sem) :- semester(Sem),unsupported_prereq,permission.
course("CSE 496", 3).
has_prereq("CSE 496").
prereq("CSE 496", Sem) :- semester(Sem),taken_before("CSE 495", Sem),permission.
course("AMS 102", 3).
has_prereq("AMS 102").
prereq("AMS 102", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
has_anti_req("AMS 102").
anti_req("AMS 102", Sem) :- semester(Sem),unsupported_anti_req.
course("AMS 103", 3).
has_prereq("AMS 103").
prereq("AMS 103", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 104", 3).
has_prereq("AMS 104").
prereq("AMS 104", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 110", 3).
has_prereq("AMS 110").
prereq("AMS 110", Sem) :- semester(Sem),unsupported_prereq.
has_anti_req("AMS 110").
anti_req("AMS 110", Sem) :- semester(Sem),unsupported_anti_req.
course("AMS 151", 3).
has_prereq("AMS 151").
prereq("AMS 151", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 161", 3).
has_prereq("AMS 161").
prereq("AMS 161", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 210", 3).
has_prereq("AMS 210").
prereq("AMS 210", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 261", 4).
has_prereq("AMS 261").
prereq("AMS 261", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 300", 1).
has_prereq("AMS 300").
prereq("AMS 300", Sem) :- semester(Sem),taken_before("WRT 102", Sem),major("AMS"),standing("U3"; "U4").
course("AMS 301", 3).
has_prereq("AMS 301").
prereq("AMS 301", Sem) :- semester(Sem),taken_before(("AMS 210"; "MAT 211"; "AMS 361"; "MAT 303"), Sem).
course("AMS 303", 3).
has_prereq("AMS 303").
prereq("AMS 303", Sem) :- semester(Sem),taken_before("AMS 301", Sem).
course("AMS 310", 3).
has_prereq("AMS 310").
prereq("AMS 310", Sem) :- semester(Sem),taken_before(("AMS 161"; "MAT 132"; "MAT 127"), Sem).
course("AMS 311", 3).
has_prereq("AMS 311").
prereq("AMS 311", Sem) :- semester(Sem),unsupported_prereq.
has_coreq("AMS 311").
coreq("AMS 311", Sem) :- semester(Sem),taken_same(("MAT 203"; "AMS 261"), Sem).
course("AMS 315", 3).
has_prereq("AMS 315").
prereq("AMS 315", Sem) :- semester(Sem),taken_before("AMS 310", Sem).
course("AMS 316", 3).
has_prereq("AMS 316").
prereq("AMS 316", Sem) :- semester(Sem),taken_before("AMS 311", Sem),taken_before("AMS 315", Sem).
course("AMS 317", 3).
has_prereq("AMS 317").
prereq("AMS 317", Sem) :- semester(Sem),taken_before("AMS 315", Sem),taken_before(("AMS 210"; "MAT 211"), Sem).
course("AMS 318", 3).
has_prereq("AMS 318").
prereq("AMS 318", Sem) :- semester(Sem),taken_before("AMS 310", Sem).
course("AMS 320", 3).
has_prereq("AMS 320").
prereq("AMS 320", Sem) :- semester(Sem),taken_before("AMS 311", Sem).
course("AMS 325", 3).
has_prereq("AMS 325").
prereq("AMS 325", Sem) :- semester(Sem),taken_before(("AMS 210"; "MAT 211"), Sem),major("AMS").
course("AMS 326", 3).
has_prereq("AMS 326").
prereq("AMS 326", Sem) :- semester(Sem),taken_before("CSE 101", Sem),taken_before("AMS 161", Sem),unsupported_prereq.
course("AMS 332", 3).
has_prereq("AMS 332").
prereq("AMS 332", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 333", 3).
has_prereq("AMS 333").
prereq("AMS 333", Sem) :- semester(Sem),taken_before(("AMS 161"; "MAT 132"), Sem),standing("U3"; "U4"),unsupported_prereq.
course("AMS 335", 3).
has_prereq("AMS 335").
prereq("AMS 335", Sem) :- semester(Sem),taken_before(("MAT 126"; "MAT 131"; "AMS 151"), Sem),passed_before(("ECO 303","C"), Sem).
course("AMS 341", 3).
has_prereq("AMS 341").
prereq("AMS 341", Sem) :- semester(Sem),taken_before(("AMS 210"; "MAT 211"; "MAT 307"), Sem),taken_before("MAT 308", Sem).
course("AMS 342", 3).
has_prereq("AMS 342").
prereq("AMS 342", Sem) :- semester(Sem),taken_before(("AMS 210"; "MAT 211"), Sem),taken_before("AMS 311", Sem).
course("AMS 345", 3).
has_prereq("AMS 345").
prereq("AMS 345", Sem) :- semester(Sem),taken_before("AMS 301", Sem),unsupported_prereq.
course("AMS 351", 3).
has_prereq("AMS 351").
prereq("AMS 351", Sem) :- semester(Sem),passed_before(("AMS 210","C"; "MAT 211","C"; "MAT 220","C"; "MAT 308","C"), Sem).
course("AMS 361", 4).
has_prereq("AMS 361").
prereq("AMS 361", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 380", 3).
has_prereq("AMS 380").
prereq("AMS 380", Sem) :- semester(Sem),taken_before(("AMS 210"; "MAT 211"; "MAT 307"), Sem),taken_before("AMS 311", Sem).
course("AMS 394", 3).
has_prereq("AMS 394").
prereq("AMS 394", Sem) :- semester(Sem),taken_before(("AMS 310"; "AMS 315"), Sem).
course("AMS 410", 3).
has_prereq("AMS 410").
prereq("AMS 410", Sem) :- semester(Sem),taken_before(("AMS 261"; "MAT 203"), Sem),taken_before("AMS 310", Sem),taken_before(("AMS 311"; "AMS 315"), Sem).
course("AMS 412", 3).
has_prereq("AMS 412").
prereq("AMS 412", Sem) :- semester(Sem),taken_before("AMS 311", Sem).
course("AMS 420", 3).
has_prereq("AMS 420").
prereq("AMS 420", Sem) :- semester(Sem),passed_before(("AMS 311","B+"), Sem).
has_advisory_prereq("AMS 420").
advisory_prereq("AMS 420", Sem) :- semester(Sem),taken_before("AMS 341", Sem).
course("AMS 441", 3).
has_prereq("AMS 441").
prereq("AMS 441", Sem) :- semester(Sem),unsupported_prereq.
course("AMS 458", 0).
course("AMS 459", 0).
has_prereq("AMS 459").
prereq("AMS 459", Sem) :- semester(Sem),taken_before("WRT 102", Sem),permission.
course("AMS 475", 3).
has_prereq("AMS 475").
prereq("AMS 475", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,permission.
course("AMS 476", 3).
has_prereq("AMS 476").
prereq("AMS 476", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,permission.
has_prereq("AMS 487").
prereq("AMS 487", Sem) :- semester(Sem),permission.
course("AMS 492", 3).
has_prereq("AMS 492").
prereq("AMS 492", Sem) :- semester(Sem),permission.
course("MAE 301", 3).
has_prereq("MAE 301").
prereq("MAE 301", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
has_coreq("MAE 301").
coreq("MAE 301", Sem) :- semester(Sem),taken_same("MAE 311", Sem).
course("MAE 302", 3).
has_prereq("MAE 302").
prereq("MAE 302", Sem) :- semester(Sem),unsupported_prereq.
course("MAE 311", 3).
has_prereq("MAE 311").
prereq("MAE 311", Sem) :- semester(Sem),taken_before("MAT 211", Sem),unsupported_prereq,unsupported_prereq.
has_coreq("MAE 311").
coreq("MAE 311", Sem) :- semester(Sem),taken_same("MAE 301", Sem).
course("MAE 312", 2).
has_prereq("MAE 312").
prereq("MAE 312", Sem) :- semester(Sem),passed_before(("MAE 311","C"), Sem).
course("MAE 330", 3).
has_prereq("MAE 330").
prereq("MAE 330", Sem) :- semester(Sem),unsupported_prereq.
course("MAE 400", 0).
course("MAE 401", 0).
has_prereq("MAE 401").
prereq("MAE 401", Sem) :- semester(Sem),permission.
course("MAE 447", 1).
course("MAE 451", 6).
has_prereq("MAE 451").
prereq("MAE 451", Sem) :- semester(Sem),taken_before("MAE 312", Sem),unsupported_prereq,taken_before("AMS 310", Sem),permission.
has_coreq("MAE 451").
coreq("MAE 451", Sem) :- semester(Sem),unsupported_coreq.
course("MAE 452", 6).
has_prereq("MAE 452").
prereq("MAE 452", Sem) :- semester(Sem),taken_before("MAE 312", Sem),unsupported_prereq,taken_before("AMS 310", Sem),permission.
has_coreq("MAE 452").
coreq("MAE 452", Sem) :- semester(Sem),unsupported_coreq.
course("MAE 454", 3).
has_coreq("MAE 454").
coreq("MAE 454", Sem) :- semester(Sem),unsupported_coreq.
course("MAP 101", 3).
course("MAP 102", 0).
has_prereq("MAP 102").
prereq("MAP 102", Sem) :- semester(Sem),permission.
course("MAP 103", 3).
course("MAT 118", 3).
has_prereq("MAT 118").
prereq("MAT 118", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 119", 1).
has_prereq("MAT 119").
prereq("MAT 119", Sem) :- semester(Sem),unsupported_prereq.
has_coreq("MAT 119").
coreq("MAT 119", Sem) :- semester(Sem),taken_same("MAT 123", Sem).
course("MAT 122", 3).
has_prereq("MAT 122").
prereq("MAT 122", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 123", 3).
has_prereq("MAT 123").
prereq("MAT 123", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 125", 3).
has_prereq("MAT 125").
prereq("MAT 125", Sem) :- semester(Sem),passed_before(("MAT 123","C"), Sem),unsupported_prereq,unsupported_prereq.
course("MAT 126", 3).
has_prereq("MAT 126").
prereq("MAT 126", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 127", 3).
has_prereq("MAT 127").
prereq("MAT 127", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 130", 1).
has_prereq("MAT 130").
prereq("MAT 130", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 131", 4).
has_prereq("MAT 131").
prereq("MAT 131", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 132", 4).
has_prereq("MAT 132").
prereq("MAT 132", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 200", 3).
has_prereq("MAT 200").
prereq("MAT 200", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 203", 4).
has_prereq("MAT 203").
prereq("MAT 203", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 211", 3).
has_prereq("MAT 211").
prereq("MAT 211", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 250", 4).
has_prereq("MAT 250").
prereq("MAT 250", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 260", 1).
has_prereq("MAT 260").
prereq("MAT 260", Sem) :- semester(Sem),permission.
course("MAT 303", 4).
has_prereq("MAT 303").
prereq("MAT 303", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 307", 4).
has_prereq("MAT 307").
prereq("MAT 307", Sem) :- semester(Sem),taken_before(("MAT 127"; "MAT 132"), Sem).
course("MAT 308", 4).
has_prereq("MAT 308").
prereq("MAT 308", Sem) :- semester(Sem),taken_before("MAT 307", Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
course("MAT 310", 4).
has_prereq("MAT 310").
prereq("MAT 310", Sem) :- semester(Sem),passed_before(("MAT 211","C"; "MAT 308","C"; "AMS 210","C"; "MAT 220","C"), Sem),unsupported_prereq.
course("MAT 311", 3).
has_prereq("MAT 311").
prereq("MAT 311", Sem) :- semester(Sem),passed_before(("MAT 312","C"; "MAT 313","C"), Sem),unsupported_prereq.
course("MAT 312", 3).
has_prereq("MAT 312").
prereq("MAT 312", Sem) :- semester(Sem),passed_before(("AMS 210","C"; "MAT 211","C"; "MAT 220","C"; "MAT 308","C"), Sem).
course("MAT 313", 3).
has_prereq("MAT 313").
prereq("MAT 313", Sem) :- semester(Sem),passed_before(("MAT 310","C"; "MAT 312","C"; "MAT 315","C"), Sem),unsupported_prereq.
course("MAT 314", 3).
has_prereq("MAT 314").
prereq("MAT 314", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 315", 4).
has_prereq("MAT 315").
prereq("MAT 315", Sem) :- semester(Sem),passed_before(("MAT 200","B"; "MAT 250","B"), Sem),unsupported_prereq,unsupported_prereq.
course("MAT 319", 4).
has_prereq("MAT 319").
prereq("MAT 319", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("MAT 320", 4).
has_prereq("MAT 320").
prereq("MAT 320", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("MAT 322", 3).
has_prereq("MAT 322").
prereq("MAT 322", Sem) :- semester(Sem),unsupported_prereq,passed_before(("MAT 310","C"; "MAT 315","C"), Sem),passed_before(("MAT 320","B"), Sem).
course("MAT 324", 3).
has_prereq("MAT 324").
prereq("MAT 324", Sem) :- semester(Sem),passed_before(("MAT 320","B"), Sem).
course("MAT 331", 3).
has_prereq("MAT 331").
prereq("MAT 331", Sem) :- semester(Sem),passed_before(("MAT 203","C"; "MAT 205","C"; "MAT 307","C"; "AMS 261","C"), Sem).
course("MAT 336", 3).
has_prereq("MAT 336").
prereq("MAT 336", Sem) :- semester(Sem),unsupported_prereq.
course("MAT 341", 3).
has_prereq("MAT 341").
prereq("MAT 341", Sem) :- semester(Sem),unsupported_prereq,passed_before(("MAT 303","C"; "MAT 305","C"; "MAT 308","C"; "AMS 361","C"), Sem).
has_advisory_prereq("MAT 341").
advisory_prereq("MAT 341", Sem) :- semester(Sem),taken_before(("MAT 200"; "MAT 250"), Sem).
course("MAT 342", 3).
has_prereq("MAT 342").
prereq("MAT 342", Sem) :- semester(Sem),unsupported_prereq.
has_advisory_prereq("MAT 342").
advisory_prereq("MAT 342", Sem) :- semester(Sem),taken_before(("MAT 200"; "MAT 250"), Sem).
course("MAT 351", 3).
has_prereq("MAT 351").
prereq("MAT 351", Sem) :- semester(Sem),unsupported_prereq,passed_before(("MAT 303","C"; "MAT 308","C"; "AMS 361","C"), Sem),unsupported_prereq.
course("MAT 360", 3).
course("MAT 362", 3).
has_prereq("MAT 362").
prereq("MAT 362", Sem) :- semester(Sem),passed_before(("MAT 319","C"; "MAT 320","C"; "MAT 364","C"), Sem),passed_before(("MAT 203","C"; "MAT 307","C"; "MAT 322","C"), Sem).
course("MAT 364", 3).
has_prereq("MAT 364").
prereq("MAT 364", Sem) :- semester(Sem),taken_before(("MAT 203"; "MAT 220"; "MAT 307"; "AMS 261"), Sem),taken_before(("MAT 200"; "MAT 250"), Sem).
has_advisory_prereq("MAT 364").
advisory_prereq("MAT 364", Sem) :- semester(Sem),taken_before(("MAT 319"; "MAT 320"), Sem).
course("MAT 371", 3).
has_prereq("MAT 371").
prereq("MAT 371", Sem) :- semester(Sem),taken_before(("CSE 113"; "CSE 150"; "CSE 215"; "MAT 200"; "MAT 250"), Sem).
course("MAT 373", 3).
has_prereq("MAT 373").
prereq("MAT 373", Sem) :- semester(Sem),passed_before(("CSE 113","C"; "CSE 150","C"; "CSE 215","C"; "MAT 200","C"; "MAT 250","C"), Sem),passed_before(("MAT 211","C"; "AMS 210","C"), Sem),passed_before(("CSE 214","C"; "CSE 260","C"), Sem),major("CSE"; "MAT"; "DAS").
course("MAT 401", 3).
has_prereq("MAT 401").
prereq("MAT 401", Sem) :- semester(Sem),unsupported_prereq,permission,unsupported_prereq.
course("MAT 402", 3).
has_prereq("MAT 402").
prereq("MAT 402", Sem) :- semester(Sem),unsupported_prereq,permission,unsupported_prereq.
course("MAT 444", 0).
has_prereq("MAT 444").
prereq("MAT 444", Sem) :- semester(Sem),unsupported_prereq,permission.
course("MAT 458", 0).
course("MAT 459", 0).
has_prereq("MAT 459").
prereq("MAT 459", Sem) :- semester(Sem),taken_before("WRT 102", Sem),permission.
course("MAT 475", 3).
has_prereq("MAT 475").
prereq("MAT 475", Sem) :- semester(Sem),permission.
has_prereq("MAT 487").
prereq("MAT 487", Sem) :- semester(Sem),permission.
course("MAT 495", 3).
has_prereq("MAT 495").
prereq("MAT 495", Sem) :- semester(Sem),permission.
course("BIO 103", 3).
course("BIO 113", 3).
course("BIO 114", 3).
course("BIO 115", 3).
course("BIO 201", 3).
has_prereq("BIO 201").
prereq("BIO 201", Sem) :- semester(Sem),unsupported_prereq.
has_advisory_prereq("BIO 201").
advisory_prereq("BIO 201", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("BIO 202", 3).
has_prereq("BIO 202").
prereq("BIO 202", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 203", 3).
has_prereq("BIO 203").
prereq("BIO 203", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 204", 2).
has_prereq("BIO 204").
prereq("BIO 204", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 205", 2).
has_prereq("BIO 205").
prereq("BIO 205", Sem) :- semester(Sem),passed_before(("BIO 204","C"), Sem).
course("BIO 207", 2).
has_prereq("BIO 207").
prereq("BIO 207", Sem) :- semester(Sem),passed_before(("BIO 204","C"), Sem).
course("BIO 208", 3).
has_advisory_prereq("BIO 208").
advisory_prereq("BIO 208", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("BIO 211", 4).
course("BIO 231", 3).
course("BIO 299", 4).
has_prereq("BIO 299").
prereq("BIO 299", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 310", 3).
has_prereq("BIO 310").
prereq("BIO 310", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem),unsupported_prereq,unsupported_prereq.
course("BIO 312", 3).
has_prereq("BIO 312").
prereq("BIO 312", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem),unsupported_prereq,unsupported_prereq.
course("BIO 314", 3).
has_prereq("BIO 314").
prereq("BIO 314", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem).
course("BIO 315", 3).
has_prereq("BIO 315").
prereq("BIO 315", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem).
course("BIO 316", 3).
has_prereq("BIO 316").
prereq("BIO 316", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 317", 3).
has_prereq("BIO 317").
prereq("BIO 317", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem).
has_advisory_prereq("BIO 317").
advisory_prereq("BIO 317", Sem) :- semester(Sem),taken_before("BIO 203", Sem).
course("BIO 319", 3).
has_advisory_prereq("BIO 319").
advisory_prereq("BIO 319", Sem) :- semester(Sem),taken_before(("AMS 110"; "BIO 211"), Sem),unsupported_advisory_prereq.
course("BIO 320", 3).
has_prereq("BIO 320").
prereq("BIO 320", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem),unsupported_prereq.
course("BIO 321", 3).
has_prereq("BIO 321").
prereq("BIO 321", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 325", 3).
has_prereq("BIO 325").
prereq("BIO 325", Sem) :- semester(Sem),passed_before(("BIO 202","C"), Sem).
course("BIO 327", 3).
has_prereq("BIO 327").
prereq("BIO 327", Sem) :- semester(Sem),passed_before(("BIO 325","C"), Sem),unsupported_prereq.
course("BIO 328", 3).
has_prereq("BIO 328").
prereq("BIO 328", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 332", 3).
has_prereq("BIO 332").
prereq("BIO 332", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 334", 3).
has_prereq("BIO 334").
prereq("BIO 334", Sem) :- semester(Sem),passed_before(("BIO 203","C"), Sem).
course("BIO 335", 3).
has_prereq("BIO 335").
prereq("BIO 335", Sem) :- semester(Sem),passed_before(("BIO 203","C"), Sem),unsupported_prereq,unsupported_prereq.
course("BIO 336", 3).
has_prereq("BIO 336").
prereq("BIO 336", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 337", 3).
has_prereq("BIO 337").
prereq("BIO 337", Sem) :- semester(Sem),passed_before(("BIO 203","C"), Sem).
course("BIO 338", 3).
has_prereq("BIO 338").
prereq("BIO 338", Sem) :- semester(Sem),unsupported_prereq.
has_advisory_prereq("BIO 338").
advisory_prereq("BIO 338", Sem) :- semester(Sem),taken_before("BIO 334", Sem).
course("BIO 339", 3).
has_prereq("BIO 339").
prereq("BIO 339", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 341", 4).
has_prereq("BIO 341").
prereq("BIO 341", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
course("BIO 342", 3).
has_prereq("BIO 342").
prereq("BIO 342", Sem) :- semester(Sem),passed_before(("BIO 201","C"; "MAR 104","C"), Sem).
has_coreq("BIO 342").
coreq("BIO 342", Sem) :- semester(Sem),taken_same("BIO 343", Sem).
course("BIO 343", 2).
has_prereq("BIO 343").
prereq("BIO 343", Sem) :- semester(Sem),passed_before(("BIO 201","C"; "MAR 104","C"), Sem).
has_coreq("BIO 343").
coreq("BIO 343", Sem) :- semester(Sem),taken_same("BIO 342", Sem).
course("BIO 344", 4).
has_prereq("BIO 344").
prereq("BIO 344", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 347", 3).
has_prereq("BIO 347").
prereq("BIO 347", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
course("BIO 348", 3).
has_prereq("BIO 348").
prereq("BIO 348", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 351", 3).
has_prereq("BIO 351").
prereq("BIO 351", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 352", 3).
has_prereq("BIO 352").
prereq("BIO 352", Sem) :- semester(Sem),passed_before(("BIO 205","C"; "BIO 207","C"), Sem).
course("BIO 353", 3).
has_prereq("BIO 353").
prereq("BIO 353", Sem) :- semester(Sem),passed_before(("BIO 201","C"; "MAR 104","C"), Sem).
has_advisory_prereq("BIO 353").
advisory_prereq("BIO 353", Sem) :- semester(Sem),taken_before("BIO 343", Sem).
course("BIO 354", 3).
has_prereq("BIO 354").
prereq("BIO 354", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 356", 2).
has_prereq("BIO 356").
prereq("BIO 356", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
course("BIO 358", 3).
has_prereq("BIO 358").
prereq("BIO 358", Sem) :- semester(Sem),standing("U3"; "U4"),unsupported_prereq.
course("BIO 361", 3).
has_prereq("BIO 361").
prereq("BIO 361", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 362", 3).
has_prereq("BIO 362").
prereq("BIO 362", Sem) :- semester(Sem),passed_before(("BIO 361","C"; "CHE 346","C"), Sem).
course("BIO 364", 3).
has_prereq("BIO 364").
prereq("BIO 364", Sem) :- semester(Sem),passed_before(("BIO 205","C"; "BIO 207","C"), Sem).
course("BIO 365", 3).
has_prereq("BIO 365").
prereq("BIO 365", Sem) :- semester(Sem),passed_before(("BIO 205","C"; "BIO 207","C"), Sem).
course("BIO 366", 4).
has_prereq("BIO 366").
prereq("BIO 366", Sem) :- semester(Sem),major("BIO"),unsupported_prereq,unsupported_prereq.
course("BIO 367", 3).
has_prereq("BIO 367").
prereq("BIO 367", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem),unsupported_prereq,unsupported_prereq.
course("BIO 368", 2).
has_prereq("BIO 368").
prereq("BIO 368", Sem) :- semester(Sem),passed_before(("BIO 315","C"), Sem).
course("BIO 369", 3).
has_prereq("BIO 369").
prereq("BIO 369", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem),passed_before(("BIO 202","C"), Sem).
course("BIO 371", 4).
has_prereq("BIO 371").
prereq("BIO 371", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem),unsupported_prereq,unsupported_prereq.
has_advisory_prereq("BIO 371").
advisory_prereq("BIO 371", Sem) :- semester(Sem),taken_before("BIO 353", Sem).
course("BIO 383", 3).
has_prereq("BIO 383").
prereq("BIO 383", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 384", 3).
has_prereq("BIO 384").
prereq("BIO 384", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("BIO 385", 3).
has_prereq("BIO 385").
prereq("BIO 385", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem).
course("BIO 386", 3).
has_prereq("BIO 386").
prereq("BIO 386", Sem) :- semester(Sem),passed_before(("BIO 201","C"), Sem),unsupported_prereq.
has_advisory_prereq("BIO 386").
advisory_prereq("BIO 386", Sem) :- semester(Sem),taken_before("MAR 104", Sem).
course("BIO 444", 0).
has_prereq("BIO 444").
prereq("BIO 444", Sem) :- semester(Sem),unsupported_prereq,permission,unsupported_prereq.
has_prereq("BIO 446").
prereq("BIO 446", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("BIO 447").
prereq("BIO 447", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("BIO 449").
prereq("BIO 449", Sem) :- semester(Sem),unsupported_prereq.
course("BIO 458", 0).
has_coreq("BIO 458").
coreq("BIO 458", Sem) :- semester(Sem),unsupported_coreq.
course("BIO 459", 0).
has_coreq("BIO 459").
coreq("BIO 459", Sem) :- semester(Sem),unsupported_coreq,unsupported_coreq.
has_prereq("BIO 475").
prereq("BIO 475", Sem) :- semester(Sem),permission,unsupported_prereq.
has_prereq("BIO 476").
prereq("BIO 476", Sem) :- semester(Sem),taken_before("BIO 475", Sem),unsupported_prereq,unsupported_prereq.
has_prereq("BIO 484").
prereq("BIO 484", Sem) :- semester(Sem),permission,unsupported_prereq.
has_prereq("BIO 486").
prereq("BIO 486", Sem) :- semester(Sem),permission,unsupported_prereq.
has_prereq("BIO 487").
prereq("BIO 487", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("BIO 488").
prereq("BIO 488", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("BIO 489").
prereq("BIO 489", Sem) :- semester(Sem),permission,unsupported_prereq.
course("CHE 115", 3).
course("CHE 129", 4).
has_prereq("CHE 129").
prereq("CHE 129", Sem) :- semester(Sem),unsupported_prereq.
course("CHE 130", 1).
course("CHE 131", 4).
has_prereq("CHE 131").
prereq("CHE 131", Sem) :- semester(Sem),unsupported_prereq.
course("CHE 132", 4).
has_prereq("CHE 132").
prereq("CHE 132", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("CHE 133", 1).
course("CHE 134", 1).
has_prereq("CHE 134").
prereq("CHE 134", Sem) :- semester(Sem),taken_before("CHE 133", Sem).
course("CHE 152", 4).
has_prereq("CHE 152").
prereq("CHE 152", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("CHE 154", 2).
has_coreq("CHE 154").
coreq("CHE 154", Sem) :- semester(Sem),taken_same("CHE 152", Sem).
course("CHE 301", 4).
has_prereq("CHE 301").
prereq("CHE 301", Sem) :- semester(Sem),taken_before(("CHE 132"; "CHE 152"), Sem),taken_before(("MAT 132"; "MAT 142"; "MAT 127"; "MAT 171"; "AMS 161"), Sem).
course("CHE 302", 4).
has_prereq("CHE 302").
prereq("CHE 302", Sem) :- semester(Sem),taken_before("CHE 301", Sem),taken_before(("MAT 203"; "MAT 211"; "AMS 210"; "AMS 261"), Sem).
course("CHE 303", 2).
has_prereq("CHE 303").
prereq("CHE 303", Sem) :- semester(Sem),taken_before(("CHE 134"; "CHE 154"), Sem).
has_coreq("CHE 303").
coreq("CHE 303", Sem) :- semester(Sem),taken_same("CHE 301", Sem).
course("CHE 304", 2).
has_prereq("CHE 304").
prereq("CHE 304", Sem) :- semester(Sem),taken_before("CHE 303", Sem).
has_coreq("CHE 304").
coreq("CHE 304", Sem) :- semester(Sem),unsupported_coreq.
course("CHE 310", 3).
has_prereq("CHE 310").
prereq("CHE 310", Sem) :- semester(Sem),taken_before(("CHE 132"; "CHE 152"), Sem).
course("CHE 312", 3).
has_prereq("CHE 312").
prereq("CHE 312", Sem) :- semester(Sem),taken_before(("CHE 132"; "CHE 152"), Sem),taken_before(("MAT 132"; "MAT 142"; "MAT 127"; "MAT 171"; "AMS 161"), Sem).
course("CHE 321", 4).
has_prereq("CHE 321").
prereq("CHE 321", Sem) :- semester(Sem),passed_before(("CHE 132","C"), Sem).
course("CHE 322", 4).
has_prereq("CHE 322").
prereq("CHE 322", Sem) :- semester(Sem),passed_before(("CHE 321","C"), Sem).
course("CHE 327", 2).
has_prereq("CHE 327").
prereq("CHE 327", Sem) :- semester(Sem),taken_before("CHE 134", Sem).
course("CHE 328", 3).
has_prereq("CHE 328").
prereq("CHE 328", Sem) :- semester(Sem),taken_before("CHE 327", Sem).
course("CHE 331", 4).
has_prereq("CHE 331").
prereq("CHE 331", Sem) :- semester(Sem),passed_before(("CHE 152","C"), Sem).
has_coreq("CHE 331").
coreq("CHE 331", Sem) :- semester(Sem),taken_same("CHE 383", Sem).
course("CHE 332", 4).
has_prereq("CHE 332").
prereq("CHE 332", Sem) :- semester(Sem),passed_before(("CHE 331","C"), Sem).
course("CHE 345", 3).
has_prereq("CHE 345").
prereq("CHE 345", Sem) :- semester(Sem),taken_before(("CHE 322"; "CHE 332"), Sem).
course("CHE 346", 3).
course("CHE 348", 3).
has_prereq("CHE 348").
prereq("CHE 348", Sem) :- semester(Sem),taken_before(("CHE 322"; "CHE 332"), Sem).
course("CHE 351", 3).
has_prereq("CHE 351").
prereq("CHE 351", Sem) :- semester(Sem),taken_before("CHE 302", Sem),taken_before(("MAT 203"; "MAT 205"), Sem).
course("CHE 353", 3).
has_prereq("CHE 353").
prereq("CHE 353", Sem) :- semester(Sem),taken_before("CHE 302", Sem),taken_before("CHE 321", Sem).
course("CHE 357", 2).
has_prereq("CHE 357").
prereq("CHE 357", Sem) :- semester(Sem),taken_before("CHE 304", Sem),taken_before(("CHE 327"; "CHE 383"), Sem).
course("CHE 358", 3).
has_prereq("CHE 358").
prereq("CHE 358", Sem) :- semester(Sem),taken_before("CHE 302", Sem),taken_before("CHE 304", Sem).
course("CHE 361", 3).
has_prereq("CHE 361").
prereq("CHE 361", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,taken_before(("AMS 161"; "MAT 127"; "MAT 132"; "MAT 142"), Sem),permission,permission.
has_coreq("CHE 361").
coreq("CHE 361", Sem) :- semester(Sem),taken_same("CHE 362", Sem).
course("CHE 362", 3).
has_coreq("CHE 362").
coreq("CHE 362", Sem) :- semester(Sem),taken_same("CHE 361", Sem).
course("CHE 375", 3).
has_prereq("CHE 375").
prereq("CHE 375", Sem) :- semester(Sem),taken_before(("CHE 322"; "CHE 332"), Sem).
course("CHE 376", 3).
has_prereq("CHE 376").
prereq("CHE 376", Sem) :- semester(Sem),taken_before("CHE 375", Sem).
course("CHE 378", 3).
has_prereq("CHE 378").
prereq("CHE 378", Sem) :- semester(Sem),taken_before(("CHE 375"; "ESG 332"), Sem).
course("CHE 379", 3).
has_prereq("CHE 379").
prereq("CHE 379", Sem) :- semester(Sem),taken_before("CHE 375", Sem).
course("CHE 383", 2).
has_prereq("CHE 383").
prereq("CHE 383", Sem) :- semester(Sem),taken_before("CHE 154", Sem).
has_coreq("CHE 383").
coreq("CHE 383", Sem) :- semester(Sem),taken_same("CHE 331", Sem).
course("CHE 384", 3).
has_prereq("CHE 384").
prereq("CHE 384", Sem) :- semester(Sem),taken_before("CHE 383", Sem).
has_coreq("CHE 384").
coreq("CHE 384", Sem) :- semester(Sem),taken_same("CHE 332", Sem).
course("CHE 385", 1).
course("CHE 444", 0).
has_prereq("CHE 444").
prereq("CHE 444", Sem) :- semester(Sem),unsupported_prereq,permission.
course("CHE 459", 0).
has_prereq("CHE 459").
prereq("CHE 459", Sem) :- semester(Sem),taken_before("WRT 102", Sem),permission.
has_prereq("CHE 461").
prereq("CHE 461", Sem) :- semester(Sem),unsupported_prereq.
course("CHE 475", 3).
has_prereq("CHE 475").
prereq("CHE 475", Sem) :- semester(Sem),permission.
course("CHE 476", 3).
has_prereq("CHE 476").
prereq("CHE 476", Sem) :- semester(Sem),permission.
course("CHE 477", 0).
has_prereq("CHE 477").
prereq("CHE 477", Sem) :- semester(Sem),taken_before("CHE 476", Sem),permission.
has_prereq("CHE 487").
prereq("CHE 487", Sem) :- semester(Sem),permission.
has_prereq("CHE 488").
prereq("CHE 488", Sem) :- semester(Sem),taken_before(("CHE 328"; "CHE 384"), Sem),permission.
course("CHE 495", 3).
has_prereq("CHE 495").
prereq("CHE 495", Sem) :- semester(Sem),standing("U4"),permission.
course("CHE 496", 3).
has_prereq("CHE 496").
prereq("CHE 496", Sem) :- semester(Sem),standing("U4"),permission.
course("PHY 112", 3).
has_prereq("PHY 112").
prereq("PHY 112", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 113", 3).
has_prereq("PHY 113").
prereq("PHY 113", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 115", 1).
course("PHY 119", 4).
has_prereq("PHY 119").
prereq("PHY 119", Sem) :- semester(Sem),taken_before("MAT 123", Sem),taken_before("CHE 131", Sem).
course("PHY 121", 4).
has_prereq("PHY 121").
prereq("PHY 121", Sem) :- semester(Sem),taken_before(("MAT 125"; "MAT 131"; "MAT 141"; "AMS 151"), Sem).
course("PHY 122", 4).
has_prereq("PHY 122").
prereq("PHY 122", Sem) :- semester(Sem),passed_before(("PHY 121","C"), Sem).
course("PHY 125", 3).
has_prereq("PHY 125").
prereq("PHY 125", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 126", 3).
has_prereq("PHY 126").
prereq("PHY 126", Sem) :- semester(Sem),passed_before(("PHY 125","C"; "PHY 131","C"; "PHY 141","C"), Sem).
course("PHY 127", 3).
has_prereq("PHY 127").
prereq("PHY 127", Sem) :- semester(Sem),passed_before(("PHY 125","C"; "PHY 131","C"; "PHY 141","C"), Sem).
course("PHY 131", 3).
has_prereq("PHY 131").
prereq("PHY 131", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 132", 3).
has_prereq("PHY 132").
prereq("PHY 132", Sem) :- semester(Sem),passed_before(("PHY 131","C"; "PHY 141","C"), Sem).
course("PHY 133", 1).
course("PHY 134", 1).
has_prereq("PHY 134").
prereq("PHY 134", Sem) :- semester(Sem),passed_before(("PHY 133","C"), Sem).
course("PHY 141", 3).
course("PHY 142", 3).
has_prereq("PHY 142").
prereq("PHY 142", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 153", 3).
has_prereq("PHY 153").
prereq("PHY 153", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 191", 1).
has_prereq("PHY 191").
prereq("PHY 191", Sem) :- semester(Sem),permission.
course("PHY 192", 1).
has_prereq("PHY 192").
prereq("PHY 192", Sem) :- semester(Sem),permission.
course("PHY 231", 3).
has_prereq("PHY 231").
prereq("PHY 231", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 237", 3).
course("PHY 251", 3).
has_prereq("PHY 251").
prereq("PHY 251", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,passed_before(("MAT 126","C"; "MAT 132","C"; "MAT 142","C"; "MAT 171","C"; "AMS 161","C"), Sem).
course("PHY 252", 1).
course("PHY 277", 3).
has_prereq("PHY 277").
prereq("PHY 277", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq,taken_before(("AMS 151"; "MAT 126"; "MAT 131"; "MAT 141"), Sem).
has_advisory_prereq("PHY 277").
advisory_prereq("PHY 277", Sem) :- semester(Sem),taken_before(("AMS 161"; "MAT 127"; "MAT 132"; "MAT 142"; "MAT 171"), Sem).
has_prereq("PHY 287").
prereq("PHY 287", Sem) :- semester(Sem),permission.
course("PHY 291", 1).
has_prereq("PHY 291").
prereq("PHY 291", Sem) :- semester(Sem),permission.
course("PHY 300", 4).
has_prereq("PHY 300").
prereq("PHY 300", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 301", 3).
has_prereq("PHY 301").
prereq("PHY 301", Sem) :- semester(Sem),unsupported_prereq,taken_before(("MAT 203"; "MAT 205"; "AMS 261"; "MAT 307"), Sem).
has_advisory_coreq("PHY 301").
advisory_coreq("PHY 301", Sem) :- semester(Sem),taken_before("MAT 341", Sem).
course("PHY 302", 3).
has_prereq("PHY 302").
prereq("PHY 302", Sem) :- semester(Sem),taken_before("PHY 301", Sem).
course("PHY 303", 3).
has_prereq("PHY 303").
prereq("PHY 303", Sem) :- semester(Sem),unsupported_prereq,taken_before(("MAT 303"; "MAT 305"; "AMS 361"; "MAT 308"), Sem).
course("PHY 306", 3).
has_prereq("PHY 306").
prereq("PHY 306", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 307", 4).
has_prereq("PHY 307").
prereq("PHY 307", Sem) :- semester(Sem),unsupported_prereq,taken_before(("MAT 132"; "MAT 142"; "MAT 127"; "MAT 171"; "AMS 161"), Sem).
has_advisory_coreq("PHY 307").
advisory_coreq("PHY 307", Sem) :- semester(Sem),taken_before(("MAT 203"; "MAT 205"; "AMS 261"; "MAT 307"), Sem).
course("PHY 308", 3).
has_prereq("PHY 308").
prereq("PHY 308", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 311", 1).
has_prereq("PHY 311").
prereq("PHY 311", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 313", 3).
has_prereq("PHY 313").
prereq("PHY 313", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
course("PHY 335", 3).
has_prereq("PHY 335").
prereq("PHY 335", Sem) :- semester(Sem),taken_before("PHY 251", Sem),taken_before("WRT 102", Sem).
course("PHY 382", 3).
has_prereq("PHY 382").
prereq("PHY 382", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 390", 3).
has_prereq("PHY 390").
prereq("PHY 390", Sem) :- semester(Sem),permission.
course("PHY 405", 3).
has_prereq("PHY 405").
prereq("PHY 405", Sem) :- semester(Sem),taken_before("PHY 303", Sem),taken_before("PHY 308", Sem),taken_before("MAT 341", Sem).
course("PHY 408", 3).
has_prereq("PHY 408").
prereq("PHY 408", Sem) :- semester(Sem),taken_before("PHY 303", Sem).
course("PHY 420", 3).
has_prereq("PHY 420").
prereq("PHY 420", Sem) :- semester(Sem),unsupported_prereq.
course("PHY 431", 3).
has_prereq("PHY 431").
prereq("PHY 431", Sem) :- semester(Sem),taken_before("PHY 308", Sem).
course("PHY 444", 0).
has_prereq("PHY 444").
prereq("PHY 444", Sem) :- semester(Sem),unsupported_prereq,permission.
course("PHY 445", 3).
has_prereq("PHY 445").
prereq("PHY 445", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("PHY 447").
prereq("PHY 447", Sem) :- semester(Sem),permission.
course("PHY 451", 3).
course("PHY 452", 3).
has_prereq("PHY 452").
prereq("PHY 452", Sem) :- semester(Sem),taken_before("PHY 300", Sem),taken_before("PHY 308", Sem).
course("PHY 458", 0).
course("PHY 459", 0).
has_prereq("PHY 459").
prereq("PHY 459", Sem) :- semester(Sem),taken_before("WRT 102", Sem),permission.
course("PHY 472", 3).
has_prereq("PHY 472").
prereq("PHY 472", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("PHY 475").
prereq("PHY 475", Sem) :- semester(Sem),permission.
has_prereq("PHY 487").
prereq("PHY 487", Sem) :- semester(Sem),permission.
course("GEO 101", 3).
course("GEO 102", 3).
course("GEO 103", 3).
course("GEO 104", 3).
has_prereq("GEO 104").
prereq("GEO 104", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 105", 3).
course("GEO 106", 3).
has_advisory_prereq("GEO 106").
advisory_prereq("GEO 106", Sem) :- semester(Sem),unsupported_advisory_prereq.
course("GEO 107", 3).
course("GEO 112", 1).
course("GEO 113", 1).
course("GEO 115", 1).
has_prereq("GEO 115").
prereq("GEO 115", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 121", 4).
course("GEO 122", 4).
has_advisory_prereq("GEO 122").
advisory_prereq("GEO 122", Sem) :- semester(Sem),unsupported_advisory_prereq.
has_prereq("GEO 287").
prereq("GEO 287", Sem) :- semester(Sem),standing("U1"; "U2"),unsupported_prereq,permission.
course("GEO 303", 3).
has_prereq("GEO 303").
prereq("GEO 303", Sem) :- semester(Sem),permission.
course("GEO 304", 3).
has_prereq("GEO 304").
prereq("GEO 304", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 305", 3).
has_prereq("GEO 305").
prereq("GEO 305", Sem) :- semester(Sem),taken_before("GEO 122 OR GEO 102", Sem),taken_before("GEO 112", Sem).
course("GEO 306", 3).
has_prereq("GEO 306").
prereq("GEO 306", Sem) :- semester(Sem),taken_before("GEO 122 OR GEO 102", Sem),taken_before("GEO 112", Sem),taken_before(("CHE 131"; "CHE 129"), Sem).
has_coreq("GEO 306").
coreq("GEO 306", Sem) :- semester(Sem),taken_same("GEO 366", Sem).
course("GEO 307", 3).
has_prereq("GEO 307").
prereq("GEO 307", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 309", 3).
has_prereq("GEO 309").
prereq("GEO 309", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq,unsupported_prereq.
has_coreq("GEO 309").
coreq("GEO 309", Sem) :- semester(Sem),taken_same("GEO 369", Sem).
course("GEO 310", 3).
has_prereq("GEO 310").
prereq("GEO 310", Sem) :- semester(Sem),unsupported_prereq,taken_before("PHY 133", Sem),taken_before(("PHY 132"; "PHY 127"; "PHY 142"), Sem).
course("GEO 311", 3).
has_prereq("GEO 311").
prereq("GEO 311", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 313", 3).
has_prereq("GEO 313").
prereq("GEO 313", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 315", 3).
has_prereq("GEO 315").
prereq("GEO 315", Sem) :- semester(Sem),taken_before(("GEO 102"; "GEO 122"), Sem),taken_before(("MAT 127"; "MAT 132"; "MAT 142"; "MAT 171"; "AMS 161"), Sem).
course("GEO 316", 4).
has_prereq("GEO 316").
prereq("GEO 316", Sem) :- semester(Sem),unsupported_prereq,taken_before(("CHE 132"; "CHE 142"), Sem).
course("GEO 318", 3).
has_prereq("GEO 318").
prereq("GEO 318", Sem) :- semester(Sem),unsupported_prereq,taken_before(("MAT 127"; "MAT 132"; "MAT 142"; "MAT 171"; "AMS 161"), Sem).
course("GEO 320", 3).
has_prereq("GEO 320").
prereq("GEO 320", Sem) :- semester(Sem),taken_before(("GEO 102"; "GEO 122"), Sem).
course("GEO 330", 3).
has_prereq("GEO 330").
prereq("GEO 330", Sem) :- semester(Sem),taken_before(("GEO 102"; "GEO 122"; "GEO 106"), Sem).
course("GEO 347", 3).
has_prereq("GEO 347").
prereq("GEO 347", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 366", 1).
has_coreq("GEO 366").
coreq("GEO 366", Sem) :- semester(Sem),taken_same("GEO 306", Sem).
course("GEO 369", 1).
has_coreq("GEO 369").
coreq("GEO 369", Sem) :- semester(Sem),taken_same("GEO 309", Sem).
course("GEO 403", 3).
has_prereq("GEO 403").
prereq("GEO 403", Sem) :- semester(Sem),taken_before("GEO 103", Sem),taken_before("GEO 113", Sem),passed_before(("GEO 306","C"), Sem),passed_before(("GEO 366","C"), Sem).
has_coreq("GEO 403").
coreq("GEO 403", Sem) :- semester(Sem),taken_same("GEO 463", Sem).
course("GEO 404", 3).
has_prereq("GEO 404").
prereq("GEO 404", Sem) :- semester(Sem),unsupported_prereq,unsupported_prereq.
has_prereq("GEO 405").
prereq("GEO 405", Sem) :- semester(Sem),unsupported_prereq.
course("GEO 407", 3).
has_prereq("GEO 407").
prereq("GEO 407", Sem) :- semester(Sem),taken_before(("MAT 125"; "MAT 131"; "AMS 151"), Sem),passed_before(("GEO 306","C"), Sem),passed_before(("GEO 366","C"), Sem).
has_coreq("GEO 407").
coreq("GEO 407", Sem) :- semester(Sem),taken_same("GEO 467", Sem).
course("GEO 444", 0).
has_prereq("GEO 444").
prereq("GEO 444", Sem) :- semester(Sem),unsupported_prereq,permission.
has_prereq("GEO 447").
prereq("GEO 447", Sem) :- semester(Sem),permission.
course("GEO 448", 1).
has_prereq("GEO 448").
prereq("GEO 448", Sem) :- semester(Sem),unsupported_prereq,permission.
course("GEO 463", 1).
has_coreq("GEO 463").
coreq("GEO 463", Sem) :- semester(Sem),taken_same("GEO 403", Sem).
course("GEO 467", 1).
has_coreq("GEO 467").
coreq("GEO 467", Sem) :- semester(Sem),taken_same("GEO 407", Sem).
course("GEO 475", 3).
has_prereq("GEO 475").
prereq("GEO 475", Sem) :- semester(Sem),standing("U4"),unsupported_prereq,unsupported_prereq,permission.
course("GEO 476", 3).
has_prereq("GEO 476").
prereq("GEO 476", Sem) :- semester(Sem),taken_before("GEO 475", Sem),unsupported_prereq,unsupported_prereq,permission.
has_prereq("GEO 487").
prereq("GEO 487", Sem) :- semester(Sem),permission.
has_prereq("GEO 488").
prereq("GEO 488", Sem) :- semester(Sem),permission.
course("GEO 496", 1).
has_prereq("GEO 496").
prereq("GEO 496", Sem) :- semester(Sem),permission.
has_coreq("GEO 496").
coreq("GEO 496", Sem) :- semester(Sem),unsupported_coreq.
course("GEO 497", 1).
has_prereq("GEO 497").
prereq("GEO 497", Sem) :- semester(Sem),taken_before("GEO 102", Sem),taken_before("GEO 112", Sem),unsupported_prereq,unsupported_prereq.
course("AST 100", 1).
course("AST 101", 3).
has_prereq("AST 101").
prereq("AST 101", Sem) :- semester(Sem),unsupported_prereq.
course("AST 105", 3).
course("AST 112", 1).
course("AST 200", 1).
course("AST 203", 4).
has_prereq("AST 203").
prereq("AST 203", Sem) :- semester(Sem),taken_before(("PHY 125"; "PHY 133"; "PHY 131"; "PHY 133"; "PHY 141"; "PHY 133"), Sem).
course("AST 205", 3).
has_prereq("AST 205").
prereq("AST 205", Sem) :- semester(Sem),taken_before(("PHY 125"; "PHY 133"; "PHY 131"; "PHY 133"; "PHY 141"; "PHY 133"), Sem).
course("AST 248", 3).
has_prereq("AST 248").
prereq("AST 248", Sem) :- semester(Sem),unsupported_prereq.
has_prereq("AST 287").
prereq("AST 287", Sem) :- semester(Sem),permission.
has_advisory_prereq("AST 287").
advisory_prereq("AST 287", Sem) :- semester(Sem),standing("U1"; "U2"),unsupported_advisory_prereq.
course("AST 301", 3).
has_prereq("AST 301").
prereq("AST 301", Sem) :- semester(Sem),unsupported_prereq,taken_before(("MAT 125"; "MAT 131"; "MAT 141"; "AMS 151"), Sem),unsupported_prereq.
course("AST 341", 3).
has_prereq("AST 341").
prereq("AST 341", Sem) :- semester(Sem),taken_before("AST 203", Sem),taken_before(("PHY 251"; "PHY 252"), Sem),taken_before("PHY 277", Sem),taken_before(("MAT 203"; "MAT 211"; "MAT 307"; "AMS 261"), Sem).
has_prereq("AST 345").
prereq("AST 345", Sem) :- semester(Sem),permission.
course("AST 346", 3).
has_prereq("AST 346").
prereq("AST 346", Sem) :- semester(Sem),taken_before("AST 203", Sem),taken_before(("PHY 251"; "PHY 252"), Sem),taken_before(("MAT 203"; "MAT 211"; "MAT 307"; "AMS 261"), Sem).
course("AST 347", 3).
has_prereq("AST 347").
prereq("AST 347", Sem) :- semester(Sem),taken_before("AST 203", Sem),taken_before(("PHY 251"; "PHY 252"), Sem),taken_before(("MAT 203"; "MAT 211"; "MAT 307"; "AMS 261"), Sem).
course("AST 389", 3).
has_prereq("AST 389").
prereq("AST 389", Sem) :- semester(Sem),taken_before("WRT 102", Sem),unsupported_prereq,unsupported_prereq.
course("AST 390", 3).
has_prereq("AST 390").
prereq("AST 390", Sem) :- semester(Sem),permission.
course("AST 443", 4).
has_prereq("AST 443").
prereq("AST 443", Sem) :- semester(Sem),taken_before("AST 203", Sem),taken_before("PHY 277", Sem),taken_before("WRT 102", Sem).
course("AST 444", 0).
has_prereq("AST 444").
prereq("AST 444", Sem) :- semester(Sem),unsupported_prereq,permission.
has_prereq("AST 447").
prereq("AST 447", Sem) :- semester(Sem),standing("U4"),permission.
course("AST 458", 0).
course("AST 459", 0).
has_prereq("AST 459").
prereq("AST 459", Sem) :- semester(Sem),taken_before("WRT 102", Sem),permission.
course("AST 475", 3).
has_prereq("AST 475").
prereq("AST 475", Sem) :- semester(Sem),standing("U4"),permission.
has_prereq("AST 487").
prereq("AST 487", Sem) :- semester(Sem),permission.
course("WRT 101", 3).
has_prereq("WRT 101").
prereq("WRT 101", Sem) :- semester(Sem),unsupported_prereq.
course("WRT 102", 3).
has_prereq("WRT 102").
prereq("WRT 102", Sem) :- semester(Sem),unsupported_prereq.
