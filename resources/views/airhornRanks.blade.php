@extends('layouts.app')

@section('styles')
<link href="css/style.css" rel="stylesheet"/>
@endsection

@section('content')
<h2>AirHorn Top 100 Rankings</h2>
<h4>Unfortunately I can't show you device IDs so the best I can do is this :(</h4>
<table class="table table-hover">
    <thead>
        <tr>
            <th>User ID</th>
            <th>Last Played DT</th>
            <th>Play Count</th>
        </tr>
    </thead>
    <tbody>
        @foreach ($ranks as $rank)
            <tr>
                <td>{{ $rank->ID }}</td>
                <td>{{ $rank->lastModDT }}</td>
                <td>{{ $rank->playCount }}</td>
            </tr>
        @endforeach
    </tbody>
</table>
@endsection