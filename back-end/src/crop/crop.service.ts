import { ForbiddenException, Injectable } from '@nestjs/common';
import { CreateCropDto } from './dto';
import { EditCropDto } from './dto/edit-crop.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class CropService {
  constructor(private prisma: PrismaService) {}

  getCrops(userId: number) {
    return this.prisma.crop.findMany({
      where: {
        userId,
      },
    });
  }

  async getAllCrops() {
    return this.prisma.crop.findMany();
  }

  getCropById(userId: number, cropId: number) {
    return this.prisma.crop.findFirst({
      where: {
        id: cropId,
        userId,
      },
    });
  }

  async createCrop(userId: number, dto: CreateCropDto) {
    return this.prisma.crop.create({
      data: {
        userId,
        ...dto,
      },
    });
  }

  async editCropById(userId: number, cropId: number, dto: EditCropDto) {
    const crop = await this.prisma.crop.findUnique({
      where: {
        id: cropId,
      },
    });

    if (!crop || crop.userId !== userId) {
      throw new ForbiddenException('Access denied to resources');
    }

    return this.prisma.crop.update({
      where: {
        id: cropId,
      },
      data: {
        ...dto,
      },
    });

  }

  async deleteCropById(userId: number, cropId: number) {
    const crop = await this.prisma.crop.findUnique({
      where: {
        id: cropId,
      },
    });

    if (!crop || crop.userId !== userId) {
      throw new ForbiddenException('Access denied to resources');
    }

    await this.prisma.crop.delete({
      where: {
        id: cropId,
      },
    });

    return `Crop ${cropId} is deleted!`
  }
}
