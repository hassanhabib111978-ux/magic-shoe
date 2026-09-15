extends Node2D

const SAVE_PATH := "user://magic_shoe_save.json"
var player := Vector2(640, 560)
var shoe := Vector2(980, 220)
var has_shoe := false
var hidden_step := false
var message := "استكشف المكان وابحث عن الحذاء السحري"
var puzzle_done := false
var clues := 0

func _ready() -> void:
    queue_redraw()
    load_progress()

func _process(delta: float) -> void:
    var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    if direction.length() > 0:
        player += direction.normalized() * 240.0 * delta
        player.x = clamp(player.x, 70.0, 1210.0)
        player.y = clamp(player.y, 120.0, 650.0)
    if Input.is_action_just_pressed("interact"):
        interact()
    queue_redraw()

func interact() -> void:
    if player.distance_to(shoe) < 90.0 and not has_shoe:
        has_shoe = true
        hidden_step = true
        message = "لقد وجدت الحذاء السحري! ✨ الخطوة الخفية أصبحت متاحة."
        save_progress()
    elif not puzzle_done and player.distance_to(Vector2(350, 300)) < 100.0:
        puzzle_done = true
        clues += 1
        message = "حللت اللغز الأول! اتبع أثر النجمة للوصول إلى الحذاء."
        save_progress()
    elif has_shoe:
        message = "مهمتك التالية: الوصول إلى العصا السحرية."

func save_progress() -> void:
    var data := {"has_shoe": has_shoe, "hidden_step": hidden_step, "puzzle_done": puzzle_done, "clues": clues}
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file:
        file.store_string(JSON.stringify(data))

func load_progress() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if not file:
        return
    var data = JSON.parse_string(file.get_as_text())
    if data is Dictionary:
        has_shoe = data.get("has_shoe", false)
        hidden_step = data.get("hidden_step", false)
        puzzle_done = data.get("puzzle_done", false)
        clues = data.get("clues", 0)
        if has_shoe:
            message = "الحذاء السحري معك. مهمة العصا السحرية مفتوحة."

func _draw() -> void:
    draw_rect(Rect2(0, 0, 1280, 720), Color("101827"))
    draw_circle(Vector2(640, 390), 285, Color("18263b"))
    draw_string(ThemeDB.fallback_font, Vector2(50, 65), "الحذاء السحري", HORIZONTAL_ALIGNMENT_LEFT, -1, 36, Color("f4d58d"))
    draw_string(ThemeDB.fallback_font, Vector2(50, 102), "المغامرة الأولى — البحث عن الأثر", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("b9c7d9"))

    draw_rect(Rect2(35, 625, 1210, 60), Color("0b111c"), true)
    draw_string(ThemeDB.fallback_font, Vector2(60, 662), message, HORIZONTAL_ALIGNMENT_LEFT, 1160, 22, Color("ffffff"))

    # puzzle stone
    draw_circle(Vector2(350, 300), 48, Color("475a72"))
    draw_circle(Vector2(350, 300), 34, Color("26364d"))
    draw_string(ThemeDB.fallback_font, Vector2(323, 307), "؟", HORIZONTAL_ALIGNMENT_LEFT, -1, 32, Color("f4d58d"))
    draw_string(ThemeDB.fallback_font, Vector2(275, 375), "لغز", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("d6dfeb"))

    # magical shoe
    if not has_shoe:
        draw_circle(shoe, 58, Color("6b4ea2"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x - 38, shoe.y + 12), "👠", HORIZONTAL_ALIGNMENT_LEFT, -1, 42, Color("ffffff"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x - 75, shoe.y + 82), "الحذاء السحري", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f4d58d"))
    else:
        draw_circle(shoe, 48, Color("30445b"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x - 30, shoe.y + 8), "✓", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color("9de3b2"))

    # player
    draw_circle(player, 28, Color("e7edf5"))
    draw_circle(player, 19, Color("607b9f"))
    draw_string(ThemeDB.fallback_font, Vector2(player.x - 14, player.y + 7), "✦", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("f4d58d"))

    draw_string(ThemeDB.fallback_font, Vector2(1010, 60), "WASD / الأسهم", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("b9c7d9"))
    draw_string(ThemeDB.fallback_font, Vector2(1010, 88), "E = تفاعل", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("b9c7d9"))
    draw_string(ThemeDB.fallback_font, Vector2(1010, 120), "النجوم: %d" % clues, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("f4d58d"))
    if has_shoe:
        draw_string(ThemeDB.fallback_font, Vector2(1010, 150), "👠 الخطوة الخفية ✓", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("9de3b2"))
