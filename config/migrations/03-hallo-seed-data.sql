-- ===================================================================
-- HALLO DIGIBUCH - SEED DATA
-- Ünite: Hallo! (Selamlaşma)
-- Aktiviteler: Video + Diyalog + Eşleştirme + Oyunlar
-- ===================================================================

-- Önce Hallo ünitesini oluştur
INSERT INTO uniteler (
    baslik,
    aciklama,
    slug,
    icon,
    kapak_gorseli,
    arkaplan_gorseli,
    sira_no,
    toplam_puan,
    durum
) VALUES (
    'Hallo!',
    'Almanca selamlaşma ve tanışma ifadelerini öğren. Buzzy ve Beezy ile birlikte temel konuşma kalıplarını keşfet!',
    'hallo',
    '👋',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    1,
    165, -- Toplam puan (40+40+15+15+15+15+15 + 10 bonus)
    'aktif'
) ON CONFLICT (slug) DO NOTHING;

-- Ünite ID'sini al
DO $$
DECLARE
    v_unite_id INTEGER;
BEGIN
    SELECT id INTO v_unite_id FROM uniteler WHERE slug = 'hallo';

-- ===================================================================
-- AKTİVİTE 1: Video - Hallo! Ich bin Buzzy!
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, durum
) VALUES (
    v_unite_id, 'hallo_video_intro', 'video', 'Hallo! Ich bin Buzzy!',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/iXR6m1w5SUI?si=L6GB0D85v5IS87I-',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 1, 'aktif'
);

-- ===================================================================
-- AKTİVİTE 2: Buzzy Beezy Listen - Hör zu (Diyalog)
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_buzzy_beezy_listen', 'buzzy_beezy_listen', 'Hör zu.',
    '{
        "instruction": {
            "text": "Hör zu und klicke auf die Texte!",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}
        },
        "parts": [
            {
                "id": "part1",
                "partNumber": 1,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Hallo!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-1-hallobuzzy.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Hallo!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1-1.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-1-hallobezzy.mp3"}}
                    }
                ],
                "mainAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}
            },
            {
                "id": "part2",
                "partNumber": 2,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Hallo! Ich heiße Buzzy. Wie heißt du?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-buzzy-1.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Hallo! Ich heiße Beezy.",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-bezzy-2.mp3"}}
                    },
                    {
                        "character": "buzzy",
                        "position": "bottom",
                        "text": "Freut mich, auch!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-buzzy-3.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "bottom",
                        "text": "Freut mich!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-4.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-bezzy-4.mp3"}}
                    }
                ],
                "mainAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}
            },
            {
                "id": "part3",
                "partNumber": 3,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-gorseli.png",
                "dialogue": [
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Wie geht es dir?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-bezzy-1.mp3"}}
                    },
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Gut. Danke! Und dir?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-buzzy-2.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "bottom",
                        "text": "Es geht mir super!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-bezzy-3.mp3"}}
                    }
                ],
                "mainAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}
            },
            {
                "id": "part4",
                "partNumber": 4,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Tschüs!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-4-buzzy-1.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Auf Wiedersehen!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-4-bezzy-2.mp3"}}
                    }
                ],
                "mainAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}},
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Hör zu und klicke auf die Texte!","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/sori-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/tam-ekran-butonu.png"}',
    40, 2, 'hallo_video_intro', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 3: Video - Wie heißt du?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_3', 'video', 'Wie heißt du? Buzzy!',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/Kooa4eScQ10?si=FLx5gw_bDpo7HYih',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 3, 'hallo_buzzy_beezy_listen', 'aktif'
);

-- ===================================================================
-- AKTİVİTE 4: Buzzy Beezy Match - Ses Eşleştirme
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_buzzy_beezy_match', 'buzzy_beezy_match', 'Hör zu und ordnet zu.',
    '{
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
                    {
                        "id": "option1",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-dogru-cevap.mp3"}},
                        "isCorrect": true
                    },
                    {
                        "id": "option2",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-yanlis-cevap.mp3"}},
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-dogru-cevap.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-1-yanlis-cevap.mp3"}}
            },
            {
                "id": "question2",
                "questionNumber": 2,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-2-gorseli.png",
                "audioOptions": [
                    {
                        "id": "option1",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-dogru-cevap.mp3"}},
                        "isCorrect": true
                    },
                    {
                        "id": "option2",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-yanlis-cevap.mp3"}},
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-dogru-cevap.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-2-yanlis-cevap.mp3"}}
            },
            {
                "id": "question3",
                "questionNumber": 3,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-3-gorseli.png",
                "audioOptions": [
                    {
                        "id": "option1",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-dogru-cevap.mp3"}},
                        "isCorrect": true
                    },
                    {
                        "id": "option2",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-yanlis-cevap.mp3"}},
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-dogru-cevap.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-3-yanlis-cevap.mp3"}}
            },
            {
                "id": "question4",
                "questionNumber": 4,
                "totalQuestions": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-4-gorseli.png",
                "audioOptions": [
                    {
                        "id": "option1",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-dogru-cevap.mp3"}},
                        "isCorrect": true
                    },
                    {
                        "id": "option2",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-yanlis-cevap.mp3"}},
                        "isCorrect": false
                    }
                ],
                "correctAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-dogru-cevap.mp3"}},
                "incorrectAudio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-2/soru-4-yanlis-cevap.mp3"}},
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Hört zu und ordnet zu.","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-2/etkinlik-2-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/soru-ses-butonu.png","progressButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/sori-ilerleme-butonu.png","fullscreenButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/tam-ekran-butonu.png","matchButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/eslestirme-butonu.png","audioButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/etkinlik-ici-ses-butonu.png","checkButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-2/tik.png"}',
    40, 4, 'hallo_video_page_3', 'aktif'
);

-- Aktiviteler devam edecek (karakter limiti nedeniyle kısaltıldı)
-- Gerisi benzer şekilde eklenecek...

END $$;
