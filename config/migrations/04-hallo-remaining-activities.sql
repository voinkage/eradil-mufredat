-- ===================================================================
-- HALLO DIGIBUCH - KALAN AKTİVİTELER (4-12)
-- ===================================================================

DO $$
DECLARE
    v_unite_id INTEGER;
    v_aktivite_3_id INTEGER;
    v_aktivite_4_id INTEGER;
    v_aktivite_5_id INTEGER;
    v_aktivite_6_id INTEGER;
    v_aktivite_7_id INTEGER;
    v_aktivite_8_id INTEGER;
    v_aktivite_9_id INTEGER;
    v_aktivite_10_id INTEGER;
    v_aktivite_11_id INTEGER;
BEGIN

-- Ünite ID'sini al
SELECT id INTO v_unite_id FROM uniteler WHERE slug = 'hallo';

IF v_unite_id IS NULL THEN
    RAISE EXCEPTION 'Hallo ünitesi bulunamadı! Önce 03-hallo-seed-data-FIXED.sql çalıştırın.';
END IF;

-- Aktivite 3 ID'sini al (önceki aktivite referansı için)
SELECT id INTO v_aktivite_3_id FROM aktiviteler 
WHERE unite_id = v_unite_id AND aktivite_id = 'hallo_video_page_3';

RAISE NOTICE 'Ünite ID: %, Aktivite 3 ID: %', v_unite_id, v_aktivite_3_id;

-- ===================================================================
-- AKTİVİTE 4: Buzzy Beezy Match
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_buzzy_beezy_match', 'buzzy_beezy_match', 'Hör zu und ordnet zu.',
    $ICERIK${
        "instruction": {
            "text": "Hört zu und ordnet zu.",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/etkinlik-2-sorusu.mp3"}}
        },
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-1-gorseli.png",
                "audioOptions": [
                    {"id": "option1", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-dogru-cevap.mp3"}}, "isCorrect": true},
                    {"id": "option2", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-yanlis-cevap.mp3"}}, "isCorrect": false}
                ]
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-2-gorseli.png",
                "audioOptions": [
                    {"id": "option1", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-dogru-cevap.mp3"}}, "isCorrect": true},
                    {"id": "option2", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-yanlis-cevap.mp3"}}, "isCorrect": false}
                ]
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-3-gorseli.png",
                "audioOptions": [
                    {"id": "option1", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-dogru-cevap.mp3"}}, "isCorrect": true},
                    {"id": "option2", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-yanlis-cevap.mp3"}}, "isCorrect": false}
                ]
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-4-gorseli.png",
                "audioOptions": [
                    {"id": "option1", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-dogru-cevap.mp3"}}, "isCorrect": true},
                    {"id": "option2", "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-yanlis-cevap.mp3"}}, "isCorrect": false}
                ],
                "isFinal": true
            }
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Hört zu und ordnet zu.","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-2/etkinlik-2-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-ses-butonu.png"}',
    40, 4, v_aktivite_3_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_4_id;

-- ===================================================================
-- AKTİVİTE 5: Audio Visual Match
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_audio_visual_match', 'buzzy_beezy_audio_visual_match', 'Was hörst du?',
    $ICERIK${
        "instruction": {
            "text": "Was hörst du? Hallo oder Tschüs?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/etkinlik-3-sorusu.mp3"}}
        },
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-1.mp3"}},
                "visualOptions": [
                    {"id": "visual1", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-1-gorseli.png", "isCorrect": true},
                    {"id": "visual2", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-1-gorseli-2.png", "isCorrect": false}
                ]
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-2.mp3"}},
                "visualOptions": [
                    {"id": "visual1", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-2-gorseli.png", "isCorrect": true},
                    {"id": "visual2", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-2-gorseli-2.png", "isCorrect": false}
                ]
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-3.mp3"}},
                "visualOptions": [
                    {"id": "visual1", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-3-gorseli.png", "isCorrect": false},
                    {"id": "visual2", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-3-gorseli-2.png", "isCorrect": true}
                ]
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-4.mp3"}},
                "visualOptions": [
                    {"id": "visual1", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-4-gorseli.png", "isCorrect": true},
                    {"id": "visual2", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-4-gorseli-2.png", "isCorrect": false}
                ],
                "isFinal": true
            }
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Was hörst du?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-3/etkinlik-3-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-ses-butonu.png"}',
    15, 5, v_aktivite_4_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_5_id;

-- ===================================================================
-- AKTİVİTE 6: Write
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_write_hallo_tschus', 'buzzy_beezy_write', 'Schreibe Hallo oder Tschüs.',
    $ICERIK${
        "instruction": {
            "text": "Schau dir das Bild an und schreibe Hallo oder Tschüs.",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-4/etkinlik-4-sorusu.mp3"}}
        },
        "questions": [
            {"id": "question1", "questionNumber": 1, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-1-gorseli.png", "correctAnswer": "Tschüs"},
            {"id": "question2", "questionNumber": 2, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-2-gorseli.png", "correctAnswer": "Hallo"},
            {"id": "question3", "questionNumber": 3, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-3-gorseli.png", "correctAnswer": "Hallo"},
            {"id": "question4", "questionNumber": 4, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-4-gorseli.png", "correctAnswer": "Tschüs", "isFinal": true}
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schreibe.","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-4/etkinlik-4-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-ses-butonu.png"}',
    15, 6, v_aktivite_5_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_6_id;

-- ===================================================================
-- AKTİVİTE 7: Text Drop
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_text_drag_match', 'buzzy_beezy_text_drop', 'Welcher Text passt?',
    $ICERIK${
        "instruction": {
            "text": "Welcher Text passt zum Bild?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-5/etkinlik-5-sorusu.mp3"}}
        },
        "textOptions": [
            {"id": "1", "label": "Es geht mir super!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/1.png"},
            {"id": "2", "label": "Tschüs!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/2.png"},
            {"id": "3", "label": "Freut mich!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/3.png"},
            {"id": "4", "label": "Hallo!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/4.png"}
        ],
        "questions": [
            {"id": "question1", "questionNumber": 1, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-1-gorseli.png", "correctOptionId": "4"},
            {"id": "question2", "questionNumber": 2, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-2-gorseli.png", "correctOptionId": "2"},
            {"id": "question3", "questionNumber": 3, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-3-gorseli.png", "correctOptionId": "4"},
            {"id": "question4", "questionNumber": 4, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-4-gorseli.png", "correctOptionId": "2", "isFinal": true}
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Welcher Text passt?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-5/etkinlik-5-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-ses-butonu.png"}',
    15, 7, v_aktivite_6_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_7_id;

-- ===================================================================
-- AKTİVİTE 8: Video
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_9', 'video', 'Hallo! Guten Morgen!',
    '{"instruction":{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube-nocookie.com/embed/DRCQRJQoPAw?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 8, v_aktivite_7_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    video_url = EXCLUDED.video_url
RETURNING id INTO v_aktivite_8_id;

-- ===================================================================
-- AKTİVİTE 9: Text Choose
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_text_choose', 'buzzy_beezy_text_choose', 'Welcher Text passt?',
    $ICERIK${
        "instruction": {
            "text": "Welcher Text passt zum Bild?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-6/etkinlik-6-sorusu.mp3"}}
        },
        "textOptions": [
            {"id": "1", "label": "Gute Nacht!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/1.png"},
            {"id": "2", "label": "Guten Tag!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/2.png"},
            {"id": "3", "label": "Guten Abend!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/3.png"},
            {"id": "4", "label": "Hallo!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/4.png"},
            {"id": "5", "label": "Guten Morgen!", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/5.png"}
        ],
        "questions": [
            {"id": "question1", "questionNumber": 1, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-1-gorseli.png", "correctOptionId": "5"},
            {"id": "question2", "questionNumber": 2, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-2-gorseli.png", "correctOptionId": "2"},
            {"id": "question3", "questionNumber": 3, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-3-gorseli.png", "correctOptionId": "1"},
            {"id": "question4", "questionNumber": 4, "totalQuestions": 4, "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-4-gorseli.png", "correctOptionId": "2", "isFinal": true}
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Welcher Text passt?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-6/etkinlik-6-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-ses-butonu.png"}',
    15, 9, v_aktivite_8_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_9_id;

-- ===================================================================
-- AKTİVİTE 10: Video
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_10', 'video', 'Wie geht es dir?',
    '{"instruction":{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/3MsdXz1OB6o?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 10, v_aktivite_9_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    video_url = EXCLUDED.video_url
RETURNING id INTO v_aktivite_10_id;

-- ===================================================================
-- AKTİVİTE 11: Image Order Swap
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_image_order_swap_7', 'buzzy_beezy_image_order_swap', 'Ordne richtig.',
    $ICERIK${
        "instruction": {
            "text": "Welche Tageszeit kommt zuerst? Ordne richtig.",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-7/etkinlik-7-sorusu.mp3"}}
        },
        "images": [
            {"id": "1", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/1.png", "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-1.png", "correctPosition": 0},
            {"id": "2", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/2.png", "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-2.png", "correctPosition": 1},
            {"id": "3", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/3.png", "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-3.png", "correctPosition": 2},
            {"id": "4", "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/4.png", "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-4.png", "correctPosition": 3}
        ]
    }$ICERIK$,
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Ordne richtig.","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-7/etkinlik-7-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/soru-ses-butonu.png"}',
    15, 11, v_aktivite_10_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_11_id;

-- ===================================================================
-- AKTİVİTE 12: Final Video
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_13', 'video', 'Final Video',
    '{"instruction":{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/mWQclMNOgN4?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 12, v_aktivite_11_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    video_url = EXCLUDED.video_url;

RAISE NOTICE '✅ HALLO ÜNİTESİ - TÜM 12 AKTİVİTE BAŞARIYLA OLUŞTURULDU!';

END $$;
