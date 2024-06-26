SCRIPT_TITLE = "Microtonal - Add Cent Difference"

function getClientInfo()
    return {
        name = SV:T(SCRIPT_TITLE),
        author = "Tsalnor",
        versionNumber = 1,
        minEditorVersion = 65537
    }
end

function main()
    local form = {
        title = SV:T(SCRIPT_TITLE),
        buttons = "OkCancel",
        widgets = {
            {
              name = "cents", type = "Slider",
              label = "Cent difference:",
              format = "%0.2f",
              minValue = -100,
              maxValue = 100,
              interval = 0.01,
              default = 0
            },
        }
    }
    local results = SV:showCustomDialog(form)
    if results.status then
        add_cent_difference_pitch_deviation(results.answers.cents)
    end
    SV:finish()
end

-- Get the cent value for a note number in a specified EDO.
function get_cents_of_edo(edo_number, note_number)
    return (note_number/edo_number*1200)%1200
end

-- Get an array of blicks for notes in the selection.
function get_notes()
    local selected_notes = SV:getMainEditor():getSelection():getSelectedNotes()
    if #selected_notes == 0 then
        return {}
    end
    table.sort(selected_notes, function(noteA, noteB)
        return noteA:getOnset() < noteB:getOnset()
    end)
    
    local notes = {}
    for i = 1, #selected_notes do
        local start_position = selected_notes[i]:getOnset()
        local end_position = selected_notes[i]:getEnd()
        notes[#notes + 1] = {start_position, end_position}
    end
    return notes
end

-- Add cent difference to parameter "Pitch Deviation".
function add_cent_difference_pitch_deviation(cent_difference)
    local notes = get_notes()
    local step = 1
    local pitch_deviation = SV:getMainEditor():getCurrentGroup():getTarget():getParameter("Pitch Deviation")
    local pitch_deviation_copy = SV:create("Automation", "Pitch Deviation")
    for i, r in ipairs(notes) do
        local points = pitch_deviation:getPoints(r[1], r[2])
        for _, p in ipairs(points) do
            pitch_deviation_copy:add(p[1], p[2])
        end
    end
    for i, r in ipairs(notes) do
        local points = pitch_deviation_copy:getPoints(r[1] + step, r[2] - step)
        pitch_deviation:remove(r[1],r[2])
        pitch_deviation:add(r[1], 0)
        pitch_deviation:add(r[2], 0)
        if not points[1] then 
            pitch_deviation:add(r[1] + step, cent_difference)
            pitch_deviation:add(r[2] - step, cent_difference)
        elseif points[1][1] == r[1] + step and points[#points][1] == r[2] - step then
            for _, p in ipairs(points) do
                pitch_deviation:add(p[1], p[2] + cent_difference)
            end
            pitch_deviation:add(r[1] + step, points[1][2] + cent_difference)
            pitch_deviation:add(r[2] - step, points[#points][2] + cent_difference)
        else
            for _, p in ipairs(points) do
                pitch_deviation:add(p[1], p[2] + cent_difference)
            end
            pitch_deviation:add(r[1] + step, cent_difference)
            pitch_deviation:add(r[2] - step, cent_difference)
        end
    end
end