<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Agenda;

class AgendaController extends Controller
{
    public function index() {
        return Agenda::all();
    }

    public function store(Request $request) {
        $request->validate([
            'judul' => 'required|string|max:255',
            'keterangan' => 'nullable|string',
            'tanggal' => 'nullable|date', // validasi tanggal
        ]);

        return Agenda::create($request->all());
    }

    public function show($id) {
        return Agenda::findOrFail($id);
    }

    public function update(Request $request, $id) {
        $request->validate([
            'judul' => 'required|string|max:255',
            'keterangan' => 'nullable|string',
            'tanggal' => 'nullable|date', // validasi tanggal
        ]);

        $agenda = Agenda::findOrFail($id);
        $agenda->update($request->all());
        return $agenda;
    }

    public function destroy($id) {
        return Agenda::destroy($id);
    }
}
