import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  UseGuards,
  ForbiddenException,
} from '@nestjs/common';
import { JwtGuard } from 'src/auth/guard/jwt.guard';
import { CropService } from './crop.service';
import { GetUser } from 'src/auth/decorator';
import { CreateCropDto } from './dto';
import { EditCropDto } from './dto/edit-crop.dto';
import { Roles } from 'src/auth/roles.decorator';
import { Role } from '@prisma/client';
import { RolesGuard } from 'src/auth/roles.guard';

@UseGuards(JwtGuard, RolesGuard)
@Controller('crops')
export class CropController {
  constructor(private cropService: CropService) {}

  @Get()
  getCrops(@GetUser('id') userId: number) {
    return this.cropService.getCrops(userId);
  }
  @Get('all-crops')
  async getAllCrops() {
    return this.cropService.getAllCrops();
  }
  @Get(':id')
  getCropById(@GetUser('id') userId: number, @Param('id', ParseIntPipe) cropId: number) {
    return this.cropService.getCropById(userId, cropId);
  }

  @Post()
  createCrops(@GetUser('role') userRole: Role, @GetUser('id') userId: number, @Body() dto: CreateCropDto) {
    if (userRole !== Role.FARMER) {
      throw new ForbiddenException('Only farmers can create crops');
    }
    return this.cropService.createCrop(userId, dto);
  }

  @Patch(':id')
  editCropById(
    @GetUser('role') userRole: Role,
    @GetUser('id') userId: number,
    @Param('id', ParseIntPipe) cropId: number,
    @Body() dto: EditCropDto,
  ) {
    if (userRole !== Role.FARMER) {
      throw new ForbiddenException('Only farmers can edit crops');
    }
    return this.cropService.editCropById(userId, cropId, dto);
  }

  @Delete(':id')
  deleteCropById(@GetUser('role') userRole: Role, @GetUser('id') userId: number, @Param('id', ParseIntPipe) cropId: number) {
    if (userRole !== Role.FARMER) {
      throw new ForbiddenException('Only farmers can delete crops');
    }
    return this.cropService.deleteCropById(userId, cropId);
  }
}
