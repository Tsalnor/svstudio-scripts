SCRIPT_TITLE = "Microtonal - Previous SynthV Note"

function getClientInfo()
    return {
        name = SV:T(SCRIPT_TITLE),
        author = "Tsalnor",
        versionNumber = 1,
        minEditorVersion = 65537
    }
end

function main()
    add_previous_synthv_pitch_deviation()
    SV:finish()
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
function add_previous_synthv_pitch_deviation()
    local selected_notes = SV:getMainEditor():getSelection():getSelectedNotes()
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
        local cent_difference = 100
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
    for i = 1, #selected_notes do
        selected_notes[i]:setPitch(selected_notes[i]:getPitch()- 1)
    end
end