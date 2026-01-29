-- ===================================================================
-- HALLO DIGIBUCH - SEED DATA PART 2
-- Kalan Aktiviteler
-- ===================================================================

DO $$
DECLARE
    v_unite_id INTEGER;
BEGIN
    SELECT id INTO v_unite_id FROM uniteler WHERE slug = 'hallo';

-- ===================================================================
-- AKTİVİTE 5: Audio Visual Match - Was hörst du?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_audio_visual_match', 'buzzy_beezy_audio_visual_match', 'Was hörst du? „Hallo" oder „Tschüs"?',
    '{
        "instruction": {
            "text": "Was hörst du? „Hallo" oder „Tschüs"?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/etkinlik-3-sorusu.mp3"}}
        },
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-1.mp3"}},
                "visualOptions": [
                    {
                        "id": "visual1",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-1-gorseli.png",
                        "isCorrect": true
                    },
                    {
                        "id": "visual2",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-1-gorseli-2.png",
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-1-dogru.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-1-yanlis.mp3"}}
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-2.mp3"}},
                "visualOptions": [
                    {
                        "id": "visual1",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-2-gorseli.png",
                        "isCorrect": true
                    },
                    {
                        "id": "visual2",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-2-gorseli-2.png",
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-2-dogru.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-2-yanlis.mp3"}}
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-3.mp3"}},
                "visualOptions": [
                    {
                        "id": "visual1",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-3-gorseli.png",
                        "isCorrect": false
                    },
                    {
                        "id": "visual2",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-3-gorseli-2.png",
                        "isCorrect": true
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-3-dogru.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-3-yanlis.mp3"}}
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-4.mp3"}},
                "visualOptions": [
                    {
                        "id": "visual1",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-4-gorseli.png",
                        "isCorrect": true
                    },
                    {
                        "id": "visual2",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-4-gorseli-2.png",
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-4-dogru.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-3/soru-4-yanlis.mp3"}},
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Was hörst du? „Hallo" oder „Tschüs"?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-3/etkinlik-3-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-ses-butonu.png","audioButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/soru-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/tam-ekran-butonu.png","checkButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/tik.png"}',
    15, 5, 'hallo_buzzy_beezy_match', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 6: Write - Schreibe Hallo oder Tschüs
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_write_hallo_tschus', 'buzzy_beezy_write', 'Schreibe Hallo oder Tschüs.',
    '{
        "instruction": {
            "text": "Schau dir das Bild an und schreibe „Hallo" oder „Tschüs".",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-4/etkinlik-4-sorusu.mp3"}}
        },
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-1-gorseli.png",
                "correctAnswer": "Tschüs"
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-2-gorseli.png",
                "correctAnswer": "Hallo"
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-3-gorseli.png",
                "correctAnswer": "Hallo"
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-4-gorseli.png",
                "correctAnswer": "Tschüs",
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Bild an und schreibe „Hallo" oder „Tschüs".","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-4/etkinlik-4-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-ses-butonu.png","audioButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/soru-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/tam-ekran-butonu.png","checkButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/tik.png","controlButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/kontrol-butonu.png","textBox":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-4/yazi-kutusu.png"}',
    15, 6, 'hallo_audio_visual_match', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 7: Text Drop - Welcher Text passt zum Bild?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_text_drag_match', 'buzzy_beezy_text_drop', 'Welcher Text passt zum Bild?',
    '{
        "instruction": {
            "text": "Welcher Text passt zum Bild?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-5/etkinlik-5-sorusu.mp3"}}
        },
        "textOptions": [
            {
                "id": "1",
                "label": "Es geht mir super!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/1.png"
            },
            {
                "id": "2",
                "label": "Tschüs!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/2.png"
            },
            {
                "id": "3",
                "label": "Freut mich!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/3.png"
            },
            {
                "id": "4",
                "label": "Hallo!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/4.png"
            }
        ],
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-1-gorseli.png",
                "correctOptionId": "4"
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-2-gorseli.png",
                "correctOptionId": "2"
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-3-gorseli.png",
                "correctOptionId": "4"
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-4-gorseli.png",
                "correctOptionId": "2",
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Welcher Text passt zum Bild?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-5/etkinlik-5-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/soru-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/tam-ekran-butonu.png","dropBox":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-5/yerlestirme-kutusu.png"}',
    15, 7, 'hallo_write_hallo_tschus', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 8: Video - Hallo! Guten Morgen!
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_9', 'video', 'Hallo! Guten Morgen!',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube-nocookie.com/embed/DRCQRJQoPAw?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 8, 'hallo_text_drag_match', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 9: Text Choose - Welcher Text passt zum Bild?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_text_choose', 'buzzy_beezy_text_choose', 'Welcher Text passt zum Bild?',
    '{
        "instruction": {
            "text": "Welcher Text passt zum Bild?",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-6/etkinlik-6-sorusu.mp3"}}
        },
        "textOptions": [
            {
                "id": "1",
                "label": "Gute Nacht!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/1.png"
            },
            {
                "id": "2",
                "label": "Guten Tag!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/2.png"
            },
            {
                "id": "3",
                "label": "Guten Abend!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/3.png"
            },
            {
                "id": "4",
                "label": "Hallo!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/4.png"
            },
            {
                "id": "5",
                "label": "Guten Morgen!",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/5.png"
            }
        ],
        "questions": [
            {
                "id": "question1",
                "questionNumber": 1,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-1-gorseli.png",
                "correctOptionId": "5"
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-2-gorseli.png",
                "correctOptionId": "2"
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-3-gorseli.png",
                "correctOptionId": "1"
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-4-gorseli.png",
                "correctOptionId": "2",
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Welcher Text passt zum Bild?","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-6/etkinlik-6-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/soru-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-6/tam-ekran-butonu.png","checkButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/tik.png"}',
    15, 9, 'hallo_video_page_9', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 10: Video - Wie geht es dir?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_10', 'video', 'Wie geht es dir?',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/3MsdXz1OB6o?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 10, 'hallo_text_choose', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 11: Image Order Swap - Welche Tageszeit kommt zuerst?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_image_order_swap_7', 'buzzy_beezy_image_order_swap', 'Welche Tageszeit kommt zuerst? Ordne richtig.',
    '{
        "instruction": {
            "text": "Welche Tageszeit kommt zuerst? Ordne richtig.",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-7/etkinlik-7-sorusu.mp3"}}
        },
        "images": [
            {
                "id": "1",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/1.png",
                "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-1.png",
                "correctPosition": 0
            },
            {
                "id": "2",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/2.png",
                "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-2.png",
                "correctPosition": 1
            },
            {
                "id": "3",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/3.png",
                "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-3.png",
                "correctPosition": 2
            },
            {
                "id": "4",
                "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/4.png",
                "frameUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/cerceve-4.png",
                "correctPosition": 3
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Welche Tageszeit kommt zuerst? Ordne richtig.","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-7/etkinlik-7-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/soru-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-7/tam-ekran-butonu.png","checkButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-3/tik.png"}',
    15, 11, 'hallo_video_page_10', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 12: Video - Final Video
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_13', 'video', 'Hallo, Wie heißt du?, Wie geht es dir?',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/mWQclMNOgN4?si',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 12, 'hallo_image_order_swap_7', 'aktif'
);

END $$;
